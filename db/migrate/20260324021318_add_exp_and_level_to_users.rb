class AddExpAndLevelToUsers < ActiveRecord::Migration[7.0]
  def change
    # expカラムを追加し、初期値を0にする
    add_column :users, :exp, :integer, default: 0
    
    # levelカラムを追加し、初期値を1にする
    add_column :users, :level, :integer, default: 1
  end
end
