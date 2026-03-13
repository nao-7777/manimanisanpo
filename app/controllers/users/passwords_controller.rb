class Users::PasswordsController < Devise::PasswordsController
  # メール送信ボタンを押した後の処理
  def create
    self.resource = resource_class.send_reset_password_instructions(resource_params)
    yield resource if block_given?

    if successfully_sent?(resource)
      # ここで強制的に「sent_modal」という印をフラッシュに入れる
      flash[:sent_modal] = true 
      respond_with({}, location: after_sending_reset_password_instructions_path_for(resource_name))
    else
      respond_with(resource)
    end
  end
  
    protected

  # パスワード更新に成功したあとの移動先を「完了画面」に固定する
  def after_resetting_password_path_for(resource)
    # 1. ユーザーを一度ログアウト（サインアウト）させる
    sign_out(resource)

    # 2. その上で完了画面へ飛ばす
    password_reset_success_path
  end
end