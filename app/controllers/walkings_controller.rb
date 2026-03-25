class WalkingsController < ApplicationController
  include Rails.application.routes.url_helpers

  def index
    @missions_with_photos = Mission.with_attached_image.order(updated_at: :desc)
    respond_to do |format|
      format.html { redirect_to new_walking_path }
      format.json {
        render json: @missions_with_photos.map { |m|
          { id: m.id, title: m.title, image_url: m.image.attached? ? url_for(m.image) : nil }
        }
      }
    end
  end

  def new
    # 💡 修正：まだ終わっていない（end_at が nil）お散歩があればそれを使い、なければ新しく作る
    @walk = current_user.walks.where(end_at: nil).first_or_create(
      start_at: Time.current, 
      steps: 0, 
      duration: 0
    )

    # 💡 お題は、このお散歩ですでにクリアしたものを避けて取得（オプション）
    # シンプルにするなら今まで通りランダムで1つ取得
    @current_mission = Mission.where(walk_id: nil).order("RANDOM()").first
    
    # 💡 これでリロードしても、この @walk に紐づくクリア済みの写真が引き継がれる
    @captured_missions = @walk.missions.with_attached_image
  end

  def update
    @walk = Walk.find(params[:id])
    
    # 💡 修正：時間ではなく walk_id でカウントする
    mission_count = @walk.missions.count
    
    steps = params[:steps].to_i
    duration_sec = params[:duration].to_i
    
    mission_exp = mission_count * 50
    steps_exp   = (steps / 100) * 10
    time_exp    = (duration_sec / 60) * 5
    total_exp   = mission_exp + steps_exp + time_exp

    if @walk.update(steps: steps, duration: duration_sec, end_at: Time.current)
      current_user.gain_exp(total_exp)
      render json: { status: 'success', redirect_url: walking_path(@walk), gained_exp: total_exp }
    else
      render json: { status: 'error' }, status: :unprocessable_entity
    end
  end

  def show
    @walk = Walk.find(params[:id])
    @mission_count = @walk.missions.count
    @mission_exp = @mission_count * 50
    @steps_exp   = (@walk.steps / 100) * 10
    @time_exp    = (@walk.duration / 60) * 5
    @total_exp   = @mission_exp + @steps_exp + @time_exp
    @captured_missions = @walk.missions.with_attached_image

    # 💡 修正：今回の獲得分を引いた「開始時のレベル」を逆算
    # 100expで1レベル上がる計算（current_user.exp は累計経験値）の場合
    previous_exp = [current_user.exp - @total_exp, 0].max
    previous_level = (previous_exp / 100) + 1
    
    # 現在のレベルと比較して、上がっていれば true
    @is_level_up = current_user.level > previous_level
  end

  def random_mission
  # 💡 1. パラメータ、または実行中のお散歩を特定する
    walk_id = params[:walk_id] || current_user.walks.where(end_at: nil).last&.id
  
  # 💡 2. 今のお散歩で「すでに保存（クリア）されたお題のタイトル」を取得
  # (お題を複製して保存する仕組みのため、タイトルで比較するのが一番確実です)
    cleared_titles = Mission.where(walk_id: walk_id).pluck(:title)

  # 💡 3. クリア済みのタイトルを除外して、マスターデータから選ぶ
    @mission = Mission.where(walk_id: nil)
                      .where.not(title: cleared_titles) # ここが重要！
                      .order("RANDOM()")
                      .first

  # もし万が一お題が尽きた場合の安全策
    if @mission.nil?
      render json: { title: "自由にお散歩を楽しもう！", id: nil, requires_photo: false }
    else
      render json: { id: @mission.id, title: @mission.title, requires_photo: @mission.requires_photo }
    end
  end

  def upload_image # メソッド名はJSと合わせるため一旦そのまま
    original_mission = Mission.find(params[:mission_id])
    walk = Walk.find(params[:walk_id])

    # 💡 写真があってもなくても、新しいMissionレコード（クリア実績）を作る
    @cleared_data = Mission.new(
      title: original_mission.title,
      requires_photo: original_mission.requires_photo,
      walk_id: walk.id
    )

    # 💡 写真があれば添付する
    if params[:image].present?
      @cleared_data.image.attach(params[:image])
    end

    if @cleared_data.save
      # 💡 ここでクリア実績としてカウントされるようになる
      image_url = @cleared_data.image.attached? ? url_for(@cleared_data.image) : nil
      
      render json: { 
        status: 'success', 
        image_url: image_url,
        current_level: current_user.level,
        exp_percent: (current_user.exp % 100)
      }
    else
      render json: { status: 'error', message: '保存に失敗しました' }, status: :unprocessable_entity
    end
  end
end