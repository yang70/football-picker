desc "This task is called by the Heroku scheduler add-on"
task :update_user_scores => :environment do
  if Time.now.strftime("%A") == "Tuesday"
    puts "$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$"
    puts "Updating game results"
    Game.get_previous_week_results
    puts "Calculating spread winners"
    Game.determine_spread_winners
    puts "Evaluating user picks"
    Game.process_user_picks
    puts "Processing user scores"
    Game.process_user_scores
    puts "Retrieve next weeks games/spreads"
    Game.get_games
    puts "Create blank picks for current week"
    Game.create_blank_picks
    puts "$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$"
  else
    puts "$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$"
    puts "Today is not Tuesday"
    puts "$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$"
  end
end

task :send_weekly_emails => :environment do
  if Time.now.strftime("%A") == "Wednesday"
    puts "$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$"
    puts "Sending weekly score emails"
    User.send_weekly_email
    puts "$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$"
  end
end

task :send_reminder_emails => :environment do
  if Time.now.strftime("%A") == "Thursday"
    puts "$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$"
    puts "Sending reminder emails"
    User.send_reminder_email
    puts "$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$"
  end
end


