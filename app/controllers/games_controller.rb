class GamesController < ApplicationController
  include GameScraper

  def index
    @games_hash = get_games
  end
end
