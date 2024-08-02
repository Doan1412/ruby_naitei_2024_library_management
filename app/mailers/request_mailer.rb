class RequestMailer < ApplicationMailer
  def rejection_email
    @request = params[:request]
    mail(to: @request.user.account.email,
         subject: t("request_mailer.failure.subject"))
  end
end
