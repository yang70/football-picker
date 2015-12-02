class ApplicationMailer < ActionMailer::Base
  default from: "no_reply@football-picker.herokuapp.com"
  layout 'mailer'
end
