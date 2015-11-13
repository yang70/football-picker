require 'capybara'
require 'capybara/poltergeist'

include Capybara::DSL

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, js_errors: false)
end

Capybara.default_driver = :poltergeist

module GameScraper
  def remove_at(string)
    if string.split.include? "At"
      string_array = string.split
      string_array.delete_at(0)
      string_array.join(' ')
    else
      string
    end
  end

  def get_games

    week_number = Rails.application.config.current_week

    current_week = Week.find_by(week: week_number)

    remove_header_array = %w(Date\ &\ Time Favorite Line Underdog Total)

    games = {}

    info_array = []

    game_number = 1

    visit "http://www.footballlocks.com/nfl_lines.shtml"

    all("tbody tr td table tr td table tbody tr td span table tbody tr td").each do |info|
        info_array << info.text unless remove_header_array.include?(info.text) || info.text == ''
    end

    info_array.delete_at(-1)

    start = 0
    finish = start + 4

    while (start < info_array.length) do
      game_array = []

      (start..finish).each do |index|
        game_array << info_array[index]
      end

      games[game_number] = game_array
      game_number += 1
      start += 5
      finish += 5
    end

    games.each do |key, value|
      value[2] = value[2].to_f
      value.delete_at(4)
    end

    games.each do |key, value|
      home = nil
      away = nil
      spread = nil
      favorite = nil
      underdog = nil

      if value[1].split.include? "At"
        home = value[3]
        away = remove_at value[1]
        spread = value[2]
      else
        home = value[1]
        away = remove_at value[3]
        spread = -value[2]
      end

      if value[2] < 0
        favorite = remove_at value[1]
        underdog = remove_at value[3]
      elsif value[2] > 0
        favorite = remove_at value[3]
        underdog = remove_at value[1]
      else
        favorite = "Pick 'em"
        underdog = "Pick 'em"
      end

      add_games = current_week.games.new(spread_for_away_team: spread, home_team: home, away_team: away, favorite: favorite, underdog: underdog, date_time: "2015-#{value[0][0..1]}-#{value[0][3..4]} #{value[0][6].to_i + 9}")
      add_games.save
    end
  end

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
end
