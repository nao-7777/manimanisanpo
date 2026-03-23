class WalkingsController < ApplicationController
  def new
    # 最初のお題を1つセットしておく
    @current_mission = Mission.order("RANDOM()").first
  end

  def create
    # お散歩終了時の保存処理をあとで書きます
  end

  # 💡 修正：requires_photo も JSON に含める
  def random_mission
    @mission = Mission.order("RANDOM()").first
    render json: { 
      title: @mission.title, 
      requires_photo: @mission.requires_photo 
    }
  end
end