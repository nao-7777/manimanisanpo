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
    @current_mission = Mission.where(walk_id: nil).order("RANDOM()").first
    # 💡 ユーザーを紐付けて作成（user_idがないとエラーになる場合があるため）
    @walk = Walk.create(user: current_user, start_at: Time.current, steps: 0, duration: 0)
    
    # 💡 修正：今回の walk に紐づく写真だけを取得（最初は必ず0件になる）
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
    
    # 💡 修正：ここも walk_id で絞り込む
    @mission_count = @walk.missions.count
    @mission_exp = @mission_count * 50
    @steps_exp   = (@walk.steps / 100) * 10
    @time_exp    = (@walk.duration / 60) * 5
    @total_exp   = @mission_exp + @steps_exp + @time_exp
    
    # 💡 修正：今回の散歩で撮った写真だけを取得
    @captured_missions = @walk.missions.with_attached_image
  end

  def random_mission
    # 💡 お題のマスターデータ（walk_idが空のもの）からランダムに選ぶ
    @mission = Mission.where(walk_id: nil).order("RANDOM()").first
    render json: { id: @mission.id, title: @mission.title, requires_photo: @mission.requires_photo }
  end

  def upload_image
    original_mission = Mission.find(params[:mission_id])

    if params[:image].present?
      # 💡 送られてきた walk_id を使って保存
      @cleared_data = Mission.create!(
        title: original_mission.title,
        requires_photo: true,
        walk_id: params[:walk_id]
      )
      
      @cleared_data.image.attach(params[:image])
      image_url = url_for(@cleared_data.image)

      render json: { status: 'success', message: '思い出を保存しました！', image_url: image_url }
    else
      render json: { status: 'error', message: '画像が見つかりません' }, status: :unprocessable_entity
    end
  end
end