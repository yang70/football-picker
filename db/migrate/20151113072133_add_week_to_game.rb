class AddWeekToGame < ActiveRecord::Migration
  def change
    add_reference :games, :week, index: true, foreign_key: true
  end
end
