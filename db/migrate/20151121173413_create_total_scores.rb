class CreateTotalScores < ActiveRecord::Migration
  def change
    create_table :total_scores do |t|
      t.integer :user_id
      t.integer :score

      t.timestamps null: false
    end
  end
end
