class WalksController < ApplicationController
  # JSからのPATCHリクエストを受け取って保存
  def update
    @walk = Walk.find(params[:id])
    if @walk.update(walk_params)
      # 💡 IDを返さず、単に成功ステータスだけ返す
      render json: { status: 'success' }, status: :ok
    else
      render json: { status: 'error', errors: @walk.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def walk_params
    params.require(:walk).permit(:end_at, :steps, :duration, :distance)
  end
end