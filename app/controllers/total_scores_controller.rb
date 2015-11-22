class TotalScoresController < ApplicationController
  before_action :authenticate_user!

  def index
    @current_user_score = TotalScore.find_by(user: current_user).score
    @scores = TotalScore.includes(:user).order(score: :desc)
  end
end
