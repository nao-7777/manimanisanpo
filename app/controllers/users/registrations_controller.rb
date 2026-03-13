class Users::RegistrationsController < Devise::RegistrationsController
  protected

  # 登録直後の自動ログインをスキップする
  def sign_up(resource_name, resource)
    # ここを空にすることで「勝手にログイン」を防ぎます
  end

  # 登録後のリダイレクト先を完了ページにする
  def after_sign_up_path_for(resource)
    signup_success_path
  end
end