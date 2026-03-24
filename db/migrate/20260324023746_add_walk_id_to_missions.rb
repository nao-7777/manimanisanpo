class AddWalkIdToMissions < ActiveRecord::Migration[7.0]
  def change
    add_column :missions, :walk_id, :integer
  end
end
