module Kirby
  class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception

    private

    def current_theme
      @current_theme = ::Kirby::Theme.find_by_name(current_account.theme)
    end
    helper_method :current_theme

    def current_kirby_user
      @current_kirby_user ||= ::Kirby::User.where(id: session[:user_id]).first if session[:user_id]
    end
    helper_method :current_kirby_user

    def current_account
      @current_account ||= ::Kirby::Account.first
    end
    helper_method :current_account

  end
end
