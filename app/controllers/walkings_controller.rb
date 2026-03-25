class WalkingsController < ApplicationController
  include Rails.application.routes.url_helpers
  # 💡 JSからのPATCH通信を許可
  skip_before_action :verify_authenticity_token, only: [:save_progress, :update]

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
    # 💡 終了していないレコードを最新順で1つ取得、なければ作成
    @walk = current_user.walks.where(end_at: nil).order(created_at: :desc).first_or_create(
      start_at: Time.current, 
      steps: 0, 
      duration: 0
    )
    @current_mission = Mission.where(walk_id: nil).order("RANDOM()").first
    @captured_missions = @walk.missions.with_attached_image
  end

  def save_progress
    @walk = current_user.walks.find(params[:id])
    # 💡 walking_params を経由して、JSからのデータを確実にDBへ保存
    if @walk.update(walking_params)
      render json: { status: 'success' }, status: :ok
    else
      render json: { status: 'error' }, status: :unprocessable_entity
    end
  end

  def update
    @walk = Walk.find(params[:id])
    
    steps = params[:steps].to_i
    duration_sec = params[:duration].to_i
    
    mission_count = @walk.missions.count
    total_exp = (mission_count * 50) + ((steps / 100) * 10) + ((duration_sec / 60) * 5)

    if @walk.update(steps: steps, duration: duration_sec, end_at: Time.current)
      current_user.gain_exp(total_exp)
      render json: { status: 'success', redirect_url: walking_path(@walk) }
    else
      render json: { status: 'error' }, status: :unprocessable_entity
    end
  end

  def show
    @walk = Walk.find(params[:id])
    @mission_count = @walk.missions.count
    @total_exp = (@mission_count * 50) + ((@walk.steps / 100) * 10) + ((@walk.duration / 60) * 5)
    @captured_missions = @walk.missions.with_attached_image
    @is_level_up = current_user.level > (([current_user.exp - @total_exp, 0].max / 100) + 1)
  end

  private

  # 💡 JS側で `walking: { ... }` 形式でも、生の `{ steps: ... }` 形式でも受け取れるようにガード
  def walking_params
    if params[:walking].present?
      params.require(:walking).permit(:steps, :duration)
    else
      params.permit(:steps, :duration)
    end
  end
end