class ApplicationController < ActionController::Base
  protected

  # 新規登録後に飛ばす先を指定
  def after_inactive_sign_up_path_for(resource)
    signup_success_path
  end

  def after_sign_up_path_for(resource)
    signup_success_path
  end

  # パスワード再設定が完了した後のリダイレクト先を指定
  def after_resetting_password_path_for(resource)
    password_reset_success_path
  end
end
