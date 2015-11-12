class GamesController < ApplicationController
  include GameScraper

  def index
    get_games
    @games = Game.all
  end
end
