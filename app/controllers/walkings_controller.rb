class WalkingsController < ApplicationController
  def index
    # すべての「画像が添付されているミッション」を、新しい順に取得
    @missions_with_photos = Mission.with_attached_image
                                   .joins(:image_attachment)
                                   .order(created_at: :desc)

    respond_to do |format|
      format.html { redirect_to new_walking_path }
      format.json {
        render json: @missions_with_photos.map { |m|
          {
            id: m.id,
            title: m.title,
            # 💡 画像のURLを確実に生成（ActiveStorage用）
            image_url: Rails.application.routes.url_helpers.rails_blob_path(m.image, only_path: true)
          }
        }
      }
    end
  end

  def new
    # 最初のお題を1つセットしておく
    @current_mission = Mission.order("RANDOM()").first
  end

  def create
    # お散歩終了時の保存処理をあとで書きます
  end

  # ランダムお題取得用のアクション
  def random_mission
    @mission = Mission.order("RANDOM()").first
    render json: { 
      title: @mission.title, 
      requires_photo: @mission.requires_photo 
    }
  end

  # 画像アップロード用のアクション
  def upload_image
    # 元々のお題データを探す
    original_mission = Mission.find(params[:mission_id])
  
    if params[:image].present?
      # 💡 重要：元のデータを更新せず、新しいMission（クリア済み用）を作成する！
      # これにより、同じ「赤いポスト」でも回数分だけアルバムに残ります。
      @cleared_data = Mission.create!(
        title: original_mission.title,
        requires_photo: true
        # もしクリア日時なども保存したければ、ここに足せます
      )
    
      # 新しく作ったレコードに画像を保存
      @cleared_data.image.attach(params[:image])
    
      render json: { status: 'success', message: '思い出を保存しました！' }
    else
      render json: { status: 'error', message: '画像が見つかりません' }, status: :unprocessable_entity
    end
  end
end