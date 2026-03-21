class MypageController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
  end

  def edit_name
    @user = current_user
    render layout: false
  end

  def update_name
    @user = current_user
    if @user.update(user_params)
      redirect_to mypage_path, notice: "名前を更新しました", status: :see_other
    else
      render :edit_name, status: :unprocessable_entity, layout: false
    end
  end

  def edit_email
    @user = current_user
    render layout: false
  end

  def update_email
    @user = current_user
    if @user.update(email_params)
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            # 1. 背後のプロフィールカードを更新
            turbo_stream.replace("user_profile", partial: "mypage/profile_card", locals: { user: @user }),
            
            # 2. 送信完了画面に差し替える
            turbo_stream.replace("modal", partial: "mypage/email_sent_modal")
        ]
        end
        format.html { redirect_to mypage_path, notice: "更新しました" }
      end
    else
      render :edit_email, status: :unprocessable_entity, layout: false
    end
  end

  private

  def user_params
    params.require(:user).permit(:name)
  end

  # 💡 メールアドレス専用の許可リストを追加
  def email_params
    params.require(:user).permit(:email)
  end
end