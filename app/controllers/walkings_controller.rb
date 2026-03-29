class WalkingsController < ApplicationController
  include Rails.application.routes.url_helpers
  skip_before_action :verify_authenticity_token, only: [:save_progress, :update, :upload_image, :complete_mission, :random_mission]

  def index
    @missions_with_photos = Mission.with_attached_image.where.not(walk_id: nil).order(created_at: :desc)
    respond_to do |format|
      format.html
      format.json { render json: @missions_with_photos.map { |m| { id: m.id, title: m.title, image_url: m.image.attached? ? url_for(m.image) : nil } } }
    end
  end

  def new
    @walk = current_user.walks.where(end_at: nil).order(created_at: :desc).first_or_create(start_at: Time.current, steps: 0, duration: 0)
    
    # 💡 修正：今回の散歩でまだクリアしていないIDから抽選
    @current_mission = Mission.where.not(id: @walk.mission_ids).order("RANDOM()").first
    @captured_missions = @walk.missions.with_attached_image
  end

  def random_mission
    walk = current_user.walks.find_by(end_at: nil)
    # 💡 修正：今回の散歩でまだクリアしていないIDから抽選
    @mission = Mission.where.not(id: walk&.mission_ids || []).order("RANDOM()").first
    
    render json: { id: @mission&.id || 0, title: @mission&.title || "全てクリア！" }
  end

  def show
    @walk = Walk.find(params[:id])
    @user_char = current_user.user_characters.first
    
    @mission_count = @walk.missions.count
    @mission_exp = @mission_count * 50
    @steps_exp = (@walk.steps / 100) * 10
    @time_exp = (@walk.duration / 60) * 5
    @total_exp = @mission_exp + @steps_exp + @time_exp

    old_exp_in_level = @user_char.exp - @total_exp
    @is_level_up = old_exp_in_level < 0 
    
    @captured_missions = @walk.missions.with_attached_image
  end

  def update
    @walk = Walk.find(params[:id])
    @user_char = current_user.user_characters.first 
    steps = params[:steps].to_i
    duration_sec = params[:duration].to_i
    
    mission_count = @walk.missions.count
    total_exp = (mission_count * 50) + ((steps / 100) * 10) + ((duration_sec / 60) * 5)

    if @walk.update(steps: steps, duration: duration_sec, end_at: Time.current)
      @user_char.gain_exp(total_exp) if @user_char
      render json: { status: 'success', redirect_url: walking_path(@walk) }
    else
      render json: { status: 'error' }, status: :unprocessable_entity
    end
  end

  def complete_mission
    @walk = current_user.walks.find(params[:id])
  
    if params[:mission_id].to_i > 0
      mission = Mission.find_by(id: params[:mission_id])
      # ここでwalk_idが更新されます
      mission.update(walk_id: @walk.id) if mission
    end

    # 💡 修正：次のお題も今回の散歩で未クリアなものから選ぶ
    next_mission = Mission.where.not(id: @walk.mission_ids).order("RANDOM()").first
  
    render json: { 
      status: 'success', 
      next_mission: { 
        id: next_mission&.id, 
        title: next_mission&.title || "全てクリア！" 
      } 
    }
  end

  def upload_image
    @walk = current_user.walks.find(params[:id])
    mission = Mission.find_by(id: params[:mission_id])
    
    if mission
      mission.image.attach(params[:image]) if params[:image].present?
      mission.update(walk_id: @walk.id)
    end

    # 💡 修正：次のお題
    next_mission = Mission.where.not(id: @walk.mission_ids).order("RANDOM()").first
    
    render json: { 
      status: 'success', 
      image_url: (mission&.image&.attached? ? url_for(mission.image) : nil), 
      next_mission: { 
        id: next_mission&.id, 
        title: next_mission&.title || "全てクリア！" 
      } 
    }
  end

  def save_progress
    @walk = current_user.walks.find(params[:id])
    if @walk.update(steps: params[:steps].to_i, duration: params[:duration].to_i)
      render json: { status: 'success' }
    else
      render json: { status: 'error' }, status: :unprocessable_entity
    end
  end

  private
  def walking_params; params.permit(:steps, :duration); end
end