class User < ApplicationRecord
  has_many :walks, dependent: :destroy
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  has_many :user_characters, dependent: :destroy
  has_many :characters, through: :user_characters
  
  after_create :add_default_character

  # 💡 ホーム画面で表示する狐の画像パスを返す
  def current_fox_image
    # ユーザーに紐づく最初のキャラクター（金宵）を取得
    active_char = user_characters.first
    
    if active_char
      # UserCharacterモデル側の判定ロジックを呼び出す
      active_char.current_avatar_path
    else
      # 万が一キャラがいない時のフォールバック画像
      "characters/koyoi_v1.png"
    end
  end

  private

  # 新規登録時に「金宵」を自動でセット
  def add_default_character
    # 名前で検索（DBに金宵のデータが既にある前提）
    first_char = Character.find_by("name LIKE ?", "%金宵%")
    
    if first_char
      # 初期レベル1、初期キャラキー "金宵" で作成
      self.user_characters.create(
        character: first_char, 
        level: 1, 
        exp: 0, 
        character_key: "金宵"
      )
    end
  end
end
