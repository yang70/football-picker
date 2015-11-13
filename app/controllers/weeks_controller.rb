class WeeksController < ApplicationController
  include GameScraper

  def index
    @weeks = Week.all
  end

  def show
    @week = Week.find(params[:id])
    @games = @week.games
  end
end
