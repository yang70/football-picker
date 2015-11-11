require 'capybara'
require 'capybara/poltergeist'

include Capybara::DSL

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, js_errors: false)
end

Capybara.default_driver = :poltergeist

module GameScraper
  def get_games

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
    games
  end
end
