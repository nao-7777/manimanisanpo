class CreateWalks < ActiveRecord::Migration[7.0]
  def change
    create_table :walks do |t|
      t.datetime :start_at
      t.datetime :end_at
      t.integer :steps
      t.integer :duration
      t.float :distance

      t.timestamps
    end
  end
end
