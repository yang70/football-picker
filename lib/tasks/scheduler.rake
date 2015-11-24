desc "This task is called by the Heroku scheduler add-on"
task :update_user_scores => :environment do
  if Time.now.strftime("%A") == "Tuesday"
    puts "$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$"
    # puts "Updating game results"
    # Game.get_previous_week_results
    puts "Calculating spread winners"
    Game.determine_spread_winners
    # puts "Evaluating user picks"
    # Game.process_user_picks
    # puts "Processing user scores"
    # Game.process_user_scores
    # puts "Retrieve next weeks games/spreads"
    # Game.get_games
    # puts "Create blank picks for current week"
    # Game.create_blank_picks
    # puts "$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$"
  else
    puts "$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$"
    puts "Today is not Tuesday"
    puts "$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$"
  end
end
