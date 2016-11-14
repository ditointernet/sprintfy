class ApplicationMailer < ActionMailer::Base
  add_template_helper(ApplicationHelper)

  default from: ENV['MAILER_SENDER']
  layout 'mailer'
end
