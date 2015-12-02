class UserMailer < ApplicationMailer
  default from: "Football_Picker@football-picker.herokuapp.com"

  def weekly_email(user, week)
    @user = user
    @week = week
    @weekly_score = WeeklyScore.find_by(user: @user, week_id: @week).score
    mail(to: @user.email, subject: "Football Picker - Week #{@week} results")
  end

  def reminder_email(user)
    @user = user
    mail(to: @user.email, subject: "Football Picker - Reminder")
  end
end
