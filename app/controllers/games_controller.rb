class GamesController < ApplicationController
  def index
    @games = get_games
  end
end
