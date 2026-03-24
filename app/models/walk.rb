class Walk < ApplicationRecord
  belongs_to :user
  has_many :missions, foreign_key: :walk_id
end
