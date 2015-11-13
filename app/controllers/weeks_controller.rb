class WeeksController < ApplicationController
  include GameScraper

  def index
    # get_games
    @weeks = Week.all
  end

  def show
    @week = Week.find(params[:id])
    if Rails.application.config.current_week > params[:id].to_i
      @games = get_results(params[:id])
    else
      @games = @week.games
    end
  end
end
