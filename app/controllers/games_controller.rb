class GamesController < ApplicationController
  include GameScraper

  def index
    # get_games
    @games = Week.first.games
  end
end
