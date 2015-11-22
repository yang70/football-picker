# require 'capybara'
# require 'capybara/poltergeist'

# include Capybara::DSL

# Capybara.register_driver :poltergeist do |app|
#   Capybara::Poltergeist::Driver.new(app, js_errors: false)
# end

# Capybara.default_driver = :poltergeist

# (1..17).each do |num|
#   Week.create!(week: num)
# end

# def get_current_week
#   start = Time.parse("2015-09-01 01:00:00 -800")

#   (Time.now.to_date - start.to_date).to_i / 7
# end

# def get_results(week)

#   teams_hash = {
#     "Cardinals"  => "Arizona",
#     "Bears"      => "Chicago",
#     "Packers"    => "Green Bay",
#     "Giants"     => "NY Giants",
#     "Lions"      => "Detroit",
#     "Redskins"   => "Washington",
#     "Eagles"     => "Philadelphia",
#     "Steelers"   => "Pittsburgh",
#     "Rams"       => "St. Louis",
#     "49ers"      => "San Francisco",
#     "Browns"     => "Cleveland",
#     "Colts"      => "Indianapolis",
#     "Cowboys"    => "Dallas",
#     "Chiefs"     => "Kansas City",
#     "Chargers"   => "San Diego",
#     "Broncos"    => "Denver",
#     "Jets"       => "NY Jets",
#     "Patriots"   => "New England",
#     "Raiders"    => "Oakland",
#     "Titans"     => "Tennessee",
#     "Bills"      => "Buffalo",
#     "Vikings"    => "Minnesota",
#     "Falcons"    => "Atlanta",
#     "Dolphins"   => "Miami",
#     "Saints"     => "New Orleans",
#     "Bengals"    => "Cincinnati",
#     "Seahawks"   => "Seattle",
#     "Buccaneers" => "Tampa Bay",
#     "Panthers"   => "Carolina",
#     "Jaguars"    => "Jacksonville",
#     "Ravens"     => "Baltimore",
#     "Texans"     => "Houston"
#   }

#   away_teams  = []
#   home_teams  = []
#   away_scores = []
#   home_scores = []

#   games = {}

#   game_number = 1

#   visit "http://espn.go.com/nfl/scoreboard/_/year/2015/seasontype/2/week/#{week}"

#   all(".away .away div h2").each do |away_team|
#     away_teams << teams_hash[away_team.text]
#   end

#   all(".home .home div h2").each do |home_team|
#     home_teams << teams_hash[home_team.text]
#   end

#   all(".away .total span").each do |away_score|
#     away_scores << away_score.text.to_i
#   end

#   all(".home .total span").each do |home_score|
#     home_scores << home_score.text.to_i
#   end

#   away_teams.each_with_index do |away_team, index|
#     games[game_number] = [away_team, away_scores[index], home_teams[index], home_scores[index]]
#     game_number += 1
#   end
#   games
# end

# current_week = get_current_week

# (1..(current_week - 1)).each do |num|
#   week = Week.find_by(week: num)

#   results = get_results(num)

#   results.each do |key, value|
#     week.games.create!(away_team: value[0], away_score: value[1], home_team: value[2], home_score: value[3])
#   end
# end

# User.create!(email: "matt@example.com", password: "password", password_confirmation: "password")

# User.create!(email: "hope@example.com", password: "password", password_confirmation: "password")

# User.create!(email: "user-1@example.com", password: "password", password_confirmation: "password")

# User.create!(email: "user-2@example.com", password: "password", password_confirmation: "password")

# def create_blank_picks(week)
#   games = Game.where(week_id: week)

#   users = User.all

#   users.each do |user|
#     games.each do |game|
#       user.picks.create!(winner: nil, game_id: game.id, week_id: week, user: user)
#     end
#   end
# end

# def determine_spread_winners(week)
#   games = Game.where(week_id: week)

#   games.each do |game|
#     if game.away_score + game.spread_for_away_team - game.home_score > 0
#       game.winner = game.away_team
#       game.save
#     elsif game.away_score + game.spread_for_away_team - game.away_score < 0
#       game.winner = game.home_team
#       game.save
#     else
#       game.winner = "Push"
#       game.save
#     end
#   end
# end

# (1..17).each do |num|
#   create_blank_picks(num)
# end

# def create_blank_weekly_scores(week)
#   users = User.all

#   users.each do |user|
#     WeeklyScore.create!(week_id: week, user: user, score: 0)
#   end
# end

# (1..17).each do |num|
#   create_blank_weekly_scores(num)
# end

# def create_blank_total_score(user)
#   TotalScore.create!(user: user)
# end

# users = User.all

# users.each do |user|
#   create_blank_total_score(user)
# end

# def remove_at(string)
#   if string.split.include? "At"
#     string_array = string.split
#     string_array.delete_at(0)
#     string_array.join(' ')
#   else
#     string
#   end
# end

# def get_games

#   week_number = get_current_week

#   current_week = Week.find_by(week: week_number)

#   remove_header_array = %w(Date\ &\ Time Favorite Line Underdog Total)

#   games = {}

#   info_array = []

#   game_number = 1

#   visit "http://www.footballlocks.com/nfl_lines.shtml"

#   all("tbody tr td table tr td table tbody tr td span table tbody tr td").each do |info|
#       info_array << info.text unless remove_header_array.include?(info.text) || info.text == ''
#   end

#   info_array.delete_at(-1)

#   start = 0
#   finish = start + 4

#   while (start < info_array.length) do
#     game_array = []

#     (start..finish).each do |index|
#       game_array << info_array[index]
#     end

#     games[game_number] = game_array
#     game_number += 1
#     start += 5
#     finish += 5
#   end

#   games.each do |key, value|
#     value[2] = value[2].to_f
#     value.delete_at(4)
#   end

#   games.each do |key, value|
#     home = nil
#     away = nil
#     spread = nil
#     favorite = nil
#     underdog = nil

#     if value[1].split.include? "At"
#       away = value[3]
#       home = remove_at value[1]
#       spread = -value[2]
#     else
#       away = value[1]
#       home = remove_at value[3]
#       spread = value[2]
#     end

#     if value[2] < 0
#       favorite = remove_at value[1]
#       underdog = remove_at value[3]
#     elsif value[2] > 0
#       favorite = remove_at value[3]
#       underdog = remove_at value[1]
#     else
#       favorite = "Pick 'em"
#       underdog = "Pick 'em"
#     end

#     add_games = current_week.games.new(spread_for_away_team: spread, home_team: home, away_team: away, favorite: favorite, underdog: underdog, date_time: "2015-#{value[0][0..1]}-#{value[0][3..4]} #{value[0][6].to_i + 9}")
#     add_games.save
#   end
# end

# get_games

# def create_blank_picks
#   current_week = get_current_week

#   current_games = Game.where(week_id: current_week)

#   users = User.all

#   users.each do |user|
#     current_games.each do |game|
#       user.picks.create(winner: nil, game_id: game.id, week_id: current_week, user: user)
#     end
#   end
# end

# def create_blank_picks(week)
#   games = Game.where(week_id: week)

#   users = User.all

#   users.each do |user|
#     games.each do |game|
#       user.picks.create!(winner: nil, game_id: game.id, week_id: week, user: user)
#     end
#   end
# end

# create_blank_picks
