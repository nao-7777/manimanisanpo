class User < ApplicationRecord
  has_many :walks, dependent: :destroy

  # :omniauthable と omniauth_providers を追加
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable,
         :omniauthable, omniauth_providers: %i[google_oauth2]

  has_many :user_characters, dependent: :destroy
  has_many :characters, through: :user_characters

  after_create :add_default_character

  # --- SNSログイン用のメソッド ---
  def self.from_omniauth(auth)
    # providerとuidでユーザーを検索し、なければ作成する
    # SNS経由の場合はパスワード入力がないため、ランダムなパスワードを生成
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.remember_me = true
      # SNSログインの場合、メール認証(confirmable)をスキップさせる設定
      user.skip_confirmation! if user.respond_to?(:skip_confirmation!)
    end
  end
  # ----------------------------

  def current_koyoi_image
    active_char = user_characters.first
    if active_char
      active_char.current_avatar_path
    else
      'characters/koyoi_v1.png'
    end
  end

  private

  def add_default_character
    first_char = Character.find_by('name LIKE ?', '%金宵%')
    return unless first_char

    user_characters.create(
      character: first_char,
      level: 1,
      exp: 0,
      character_key: 'koyoi'
    )
  end
end
