class WalkingsController < ApplicationController
  # 💡 ヘルパーを読み込んで url_for を使えるようにする
  include Rails.application.routes.url_helpers

  def index
    @missions_with_photos = Mission.with_attached_image
                                   .order(updated_at: :desc)

    respond_to do |format|
      format.html { redirect_to new_walking_path }
      format.json {
        render json: @missions_with_photos.map { |m|
          {
            id: m.id,
            title: m.title,
            image_url: m.image.attached? ? url_for(m.image) : nil
          }
        }
      }
    end
  end

  def new
    @current_mission = Mission.order("RANDOM()").first
    @walk = Walk.create(start_at: Time.current, steps: 0, duration: 0)
  end

  def random_mission
    @mission = Mission.order("RANDOM()").first
    render json: { 
      id: @mission.id, # 💡 IDを返さないとクリア時にどのお題か判別できないので追加
      title: @mission.title, 
      requires_photo: @mission.requires_photo 
    }
  end

  # 💡 ここを修正：保存した画像のURLをJSONで返すようにしました
  def upload_image
    original_mission = Mission.find(params[:mission_id])
  
    if params[:image].present?
      # 新しいクリア済みレコードを作成
      @cleared_data = Mission.create!(
        title: original_mission.title,
        requires_photo: true
      )
    
      # 画像を添付
      @cleared_data.image.attach(params[:image])
    
      # 💡 【重要】保存した画像のURLを生成してフロントに返す
      # url_for を使うことで、ActiveStorageの有効なURLが送られます
      image_url = url_for(@cleared_data.image)

      render json: { 
        status: 'success', 
        message: '思い出を保存しました！',
        image_url: image_url # 💡 これが JS の addPhotoToAlbum に渡る
      }
    else
      render json: { status: 'error', message: '画像が見つかりません' }, status: :unprocessable_entity
    end
  end
end