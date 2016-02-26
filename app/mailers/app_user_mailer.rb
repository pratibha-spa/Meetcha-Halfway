class AppUserMailer < ApplicationMailer
	def recover_password_email(app_user)
    recipient = app_user.email
    @secret_p = app_user.unhashed_password
    mail(to: recipient, subject: "Meetcha-Halfway recover password") rescue nil
  end
end
