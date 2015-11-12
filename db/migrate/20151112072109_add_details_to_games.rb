class AddDetailsToGames < ActiveRecord::Migration
  def change
    add_column :games, :date_time, :datetime
    add_column :games, :home_team, :string
    add_column :games, :away_team, :string
    add_column :games, :favorite, :string
    add_column :games, :underdog, :string
    add_column :games, :spread_for_away_team, :decimal
    add_column :games, :week, :integer
  end
end
