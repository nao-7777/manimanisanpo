require 'rails_helper'

RSpec.describe "Users::OmniauthCallbacks", type: :request do
  describe "Google OAuth ログイン" do
    let!(:koyoi) do
      Character.find_or_create_by!(name: "金宵") do |c|
        c.rarity = 1 # もしバリデーションで必須なら入れる
        c.description = "テスト用説明"
      end
    end

    before do
      OmniAuth.config.test_mode = true
      OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
                                                                           provider: 'google_oauth2',
                                                                           uid: '123456',
                                                                           info: {
                                                                             email: 'test@example.com',
                                                                             name: 'テストユーザー'
                                                                           }
                                                                         })
    end

    it "Googleログイン後にユーザーが作成され、初期キャラクター（金宵）が付与されること" do
      expect do
        post user_google_oauth2_omniauth_authorize_path
        follow_redirect!
      end.to change(User, :count).by(1)

      user = User.last
      expect(user.characters).to include(koyoi)
      expect(response).to redirect_to("/welcome")
    end
  end
end
