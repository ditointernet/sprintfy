# Preview all emails at http://localhost:3000/rails/mailers/squad_manager_mailer
class SquadManagerMailerPreview < ActionMailer::Preview
  def sprint_report_email
    SquadManagerMailer.sprint_report_email(Sprint.last)
  end
end
