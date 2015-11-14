class WeeksController < ApplicationController
  include GameScraper

  def index
    @weeks = Week.all
  end

  def show
    # get_games
    @week = Week.find(params[:id])
    @games = @week.games
  end
end
