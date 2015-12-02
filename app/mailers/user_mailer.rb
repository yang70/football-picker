class UserMailer < ApplicationMailer
  default from: "no_reply@football-picker.herokuapp.com"

  def weekly_email(user, week)
    @user = user
    @week = week
    @weekly_score = @user.weekly_score.where(week_id: @week).score
    mail(to: @user.email, subject: "Football Picker - Week #{@week} results")
  end
end
