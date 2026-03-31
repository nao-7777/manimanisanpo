class StoriesController < ApplicationController
  def introduction
  end

  def finish
    # 初回ログインフラグを false に更新して、二度とこの画面が出ないようにする
    current_user.update(first_login: false)
    
    # ホーム画面（root）へリダイレクト
    redirect_to root_path
  end
end
