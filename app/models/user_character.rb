class UserCharacter < ApplicationRecord
  belongs_to :user
  belongs_to :character

  # 次のレベルまでに必要なEXPを計算
  def required_exp_for_next_level
    level * 500
  end

  # 経験値を加算し、レベルアップをチェックする
  def gain_exp(amount)
    # self.exp が nil の場合に備えて 0 をデフォルトにする
    self.exp ||= 0
    self.level ||= 1
    
    self.exp += amount
    
    # 経験値が溜まっている間、レベルを上げ続ける
    while exp >= required_exp_for_next_level
      self.exp -= required_exp_for_next_level
      self.level += 1
    end
    
    save!
  end

  # 初期値を「金宵（こよい）」にする
  DEFAULT_CHARACTER_KEY = "金宵"

  def current_avatar_path
    # character_key が空なら "金宵" を使う（安全策）
    key = self.character_key.presence || DEFAULT_CHARACTER_KEY
    
    # レベル10以上なら進化後
    version = self.level >= 10 ? "v2" : "v1"
    
    # assets 配下にある画像を指すパス
    "characters/#{key}_#{version}.png"
  end
end
