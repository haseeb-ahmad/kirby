module Kirby
  class UserMailer < ActionMailer::Base
    layout 'kirby/mail'

    def forgot_password(user)
      @user = user

      mail(
        to: @user.email,
        from: current_account.email,
        subject: t('kirby.forgot_password.mail_subject')
      )
    end

    private

    def current_account
      Kirby::Account.first
    end
  end
end
