class Mission < ApplicationRecord
  belongs_to :walk, foreign_key: :walk_id, optional: true
  has_one_attached :image
end
