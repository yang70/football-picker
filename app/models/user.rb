class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :picks
  has_many :weekly_scores
  has_one :total_score

  after_create :setup_blank_picks, :setup_scores

  def self.send_weekly_email
    week = get_current_week - 1

    users = User.all

    users.each do |user|
      UserMailer.weekly_email(user, week).deliver_now
    end
  end

  protected

  def get_current_week
    start = Time.parse("2015-09-01 01:00:00 -800")

    (Time.now.to_date - start.to_date).to_i / 7
  end  

  def setup_blank_picks
   games = Game.all

   games.each do |game|
     self.picks.create(winner: nil, game_id: game.id, week_id: game.week_id, user: self)
   end
  end  

  def setup_scores
    TotalScore.create(user: self)

    (1..17).each do |num|
      WeeklyScore.create(week_id: num, user: self, score: 0)
    end 
  end

end
