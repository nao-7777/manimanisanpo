class TopController < ApplicationController
  def index
    if user_signed_in?
      # ログイン済みなら「app/views/top/home.html.erb」を表示
      render :home
    else
      # 未ログインなら「app/views/top/index.html.erb」を表示
      render :index
    end
  end
end