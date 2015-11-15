class Week < ActiveRecord::Base
  has_many :games

  def puts_it
    puts "$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$"
    puts "This is a cron test!"
  end
end
