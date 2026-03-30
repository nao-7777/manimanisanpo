class RemoveExpAndLevelFromUsers < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :exp, :integer
    remove_column :users, :level, :integer
  end
end
