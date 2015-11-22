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
    # process_user_picks current_user
    # process_user_scores current_user
    get_results(2)
    get_results(7)
    @week = Week.find(params[:id])
    @games = @week.games
    @weekly_score = WeeklyScore.find_by(week_id: @week, user: current_user).score
    @total_score = TotalScore.find_by(user: current_user).score
    @game_picks = {}
    @games.each do |game|
      @game_picks[game] = current_user.picks.find_by(game_id: game.id)
    end
  end
end
