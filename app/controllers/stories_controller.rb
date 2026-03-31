class StoriesController < ApplicationController
  def introduction
  end

  def finish
    # 1. 念のため最新のDB状態をモデルに再読み込みさせる（超重要）
    User.reset_column_information

    # 2. カラムが存在する場合のみ更新する（エラーで止まるのを防ぐ）
    if current_user.respond_to?(:first_login)
      current_user.update_columns(first_login: false)
    else
      # 万が一カラムが見えていなくても、ログに残してホームへ飛ばす（詰まりを解消）
      logger.error "Column first_login not found in finish action."
    end
    
    redirect_to root_path
  end
end
