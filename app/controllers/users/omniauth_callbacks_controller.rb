module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    # Googleからの通知を安全に受け取るための設定
    skip_before_action :verify_authenticity_token, only: :google_oauth2

    def google_oauth2
      # Googleから届いた情報を元にユーザーを探す、または作成する
      @user = User.from_omniauth(request.env['omniauth.auth'])

      if @user.persisted?
        # ログイン成功時
        sign_in_and_redirect @user, event: :authentication
        set_flash_message(:notice, :success, kind: 'Google') if is_navigational_format?
      else
        # 失敗時：登録画面へ戻す
        session['devise.google_data'] = request.env['omniauth.auth'].except(:extra)
        redirect_to new_user_registration_url, alert: @user.errors.full_messages.join("\n")
      end
    end

    def failure
      redirect_to root_path
    end
  end
end
