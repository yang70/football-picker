class WeeksController < ApplicationController
  before_action :authenticate_user!

  include GameScraper

  def index
    @weeks = Week.all
  end

  def show
    # get_previous_week_results
    # determine_spread_winners
    # get_games
    # create_blank_picks
    @week = Week.find(params[:id])
    @games = @week.games
    @game_picks = {}
    @games.each do |game|
      @game_picks[game] = current_user.picks.find_by(game_id: game.id)
    end
  end
end
