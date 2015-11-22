class CreateWeeklyScores < ActiveRecord::Migration
  def change
    create_table :weekly_scores do |t|
      t.integer :week_id
      t.integer :user_id
      t.integer :score

      t.timestamps null: false
    end
  end
end
