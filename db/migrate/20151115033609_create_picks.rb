class CreatePicks < ActiveRecord::Migration
  def change
    create_table :picks do |t|
      t.string :winner
      t.integer :game_id
      t.integer :week_id
      t.timestamps null: false
    end
  end
end
