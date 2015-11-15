class CreatePicks < ActiveRecord::Migration
  def change
    create_table :picks do |t|
      t.boolean :winner
      t.integer :game_id
      t.timestamps null: false
    end
  end
end
