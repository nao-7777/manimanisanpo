class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # belongs_to :user
  has_many :walks, dependent: :destroy
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  # 💡 追加：レベルに応じて画像名を返すメソッド
  def fox_image_name
    if level && level >= 10
      "fox_stage2.png" # 進化後のファイル名
    else
      "いらすとや狐.png" # 初期のファイル名
    end
  end

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
end
