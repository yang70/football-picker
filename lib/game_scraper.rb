require 'capybara'
require 'capybara/poltergeist'

include Capybara::DSL

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, js_errors: false)
end

Capybara.default_driver = :poltergeist

module GameScraper

  def get_current_week
    start = Time.parse("2015-09-01 01:00:00 -800")

    (Time.now.to_date - start.to_date).to_i / 7
  end

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

    week_number = get_current_week

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
        away = value[3]
        home = remove_at value[1]
        spread = -value[2]
      else
        away = value[1]
        home = remove_at value[3]
        spread = value[2]
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

    teams_hash = {
      "Cardinals"  => "Arizona",
      "Bears"      => "Chicago",
      "Packers"    => "Green Bay",
      "Giants"     => "NY Giants",
      "Lions"      => "Detroit",
      "Redskins"   => "Washington",
      "Eagles"     => "Philadelphia",
      "Steelers"   => "Pittsburgh",
      "Rams"       => "St. Louis",
      "49ers"      => "San Francisco",
      "Browns"     => "Cleveland",
      "Colts"      => "Indianapolis",
      "Cowboys"    => "Dallas",
      "Chiefs"     => "Kansas City",
      "Chargers"   => "San Diego",
      "Broncos"    => "Denver",
      "Jets"       => "NY Jets",
      "Patriots"   => "New England",
      "Raiders"    => "Oakland",
      "Titans"     => "Tennessee",
      "Bills"      => "Buffalo",
      "Vikings"    => "Minnesota",
      "Falcons"    => "Atlanta",
      "Dolphins"   => "Miami",
      "Saints"     => "New Orleans",
      "Bengals"    => "Cincinnati",
      "Seahawks"   => "Seattle",
      "Buccaneers" => "Tampa Bay",
      "Panthers"   => "Carolina",
      "Jaguars"    => "Jacksonville",
      "Ravens"     => "Baltimore",
      "Texans"     => "Houston"
    }

    away_teams  = []
    home_teams  = []
    away_scores = []
    home_scores = []

    games = {}

    game_number = 1

    visit "http://espn.go.com/nfl/scoreboard/_/year/2015/seasontype/2/week/#{week}"

    all(".away .away div h2").each do |away_team|
      away_teams << teams_hash[away_team.text]
    end

    all(".home .home div h2").each do |home_team|
      home_teams << teams_hash[home_team.text]
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

  def create_blank_picks
    current_week = get_current_week

    current_games = Game.where(week_id: current_week)

    users = User.all

    users.each do |user|
      current_games.each do |game|
        user.picks.create(winner: nil, game_id: game.id, week_id: current_week, user: user)
      end
    end
  end

  def get_previous_week_results
    previous_week = get_current_week - 1

    results = get_results(previous_week)

    results.each do |key, value|
      game = Game.find_by(home_team: value[2], week_id: previous_week)
      game.away_score = value[1]
      game.save
      game.home_score = value[3]
      game.save
    end
  end

  def determine_spread_winners
    previous_week = get_current_week - 1

    games = Game.where(week_id: previous_week)

    games.each do |game|
      if game.away_score + game.spread_for_away_team - game.home_score > 0
        game.winner = game.away_team
        game.save
      elsif game.away_score + game.spread_for_away_team - game.home_score < 0
        game.winner = game.home_team
        game.save
      else
        game.winner = "Push"
        game.save
      end
    end
  end

  def process_user_picks(user)
    previous_week = get_current_week - 1

    games = Game.where(week: previous_week)

    games.each do |game|
      pick = Pick.where('user_id= ? AND game_id= ?', user.id, game.id)[0]
      if pick.winner.nil?
        pick.correct = false
        pick.save
      elsif pick.winner == game.winner
        pick.correct = true
        pick.save
      else
        pick.correct = false
        pick.save
      end
    end
  end

  def process_user_scores(user)
    previous_week = get_current_week - 1

    weekly_score = WeeklyScore.find_by(week_id: previous_week, user: user)

    total_score = TotalScore.find_by(user: user)

    games = Game.where(week: previous_week)

    weekly_total = 0

    games.each do |game|
      pick = Pick.find_by(user: user, game_id: game.id)
      if pick.winner && pick.winner == game.winner
        weekly_total += 1
      end
    end

    weekly_score.score = weekly_total
    weekly_score.save
    total_score.score += weekly_total
    total_score.save
  end
end
