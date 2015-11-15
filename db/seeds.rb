require 'capybara'
require 'capybara/poltergeist'

include Capybara::DSL

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, js_errors: false)
end

Capybara.default_driver = :poltergeist

(1..17).each do |num|
  Week.create!(week: num)
end

current_week = Rails.application.config.current_week

def get_results(week)

  away_teams  = []
  home_teams  = []
  away_scores = []
  home_scores = []

  games = {}

  game_number = 1

  visit "http://espn.go.com/nfl/scoreboard/_/year/2015/seasontype/2/week/#{week}"

  all(".away .away div h2").each do |away_team|
    away_teams << away_team.text
  end

  all(".home .home div h2").each do |home_team|
    home_teams << home_team.text
  end

  all(".away .total span").each do |away_score|
    away_scores << away_score.text.to_i
  end

  all(".home .total span").each do |home_score|
    home_scores << home_score.text.to_i
  end

  away_teams.each_with_index do |away_team, index|
    games[game_number] = [away_team, away_scores[index], home_teams[index], home_scores[index]]
    game_number += 1
  end
  games
end

(1..(current_week - 1)).each do |num|
  week = Week.find_by(week: num)

  results = get_results(num)

  results.each do |key, value|
    week.games.create!(away_team: value[0], away_score: value[1], home_team: value[2], home_score: value[3])
  end
end

User.create!(email: "matt@example.com", password: "password", password_confirmation: "password")
