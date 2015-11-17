class ApplicationController < ActionController::Base
  include GameScraper
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def after_sign_in_path_for(resource)
    current_week = get_current_week
    "/weeks/#{current_week}"
  end
end
