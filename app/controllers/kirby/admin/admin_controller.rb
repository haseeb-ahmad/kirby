module Kirby
  module Admin
    class AdminController < ::Kirby::ApplicationController
      before_action :set_admin_locale
      before_action :authorize_kirby_user

      def current_admin_path
        request.fullpath[%r{/#{ Kirby.config.backend_path }(.*)}, 1]
      end
      helper_method :current_admin_path

      private

      def set_admin_locale
        I18n.locale = I18n.default_locale
      end

      def authorize_kirby_user
        redirect_to admin_login_path, flash: {information: I18n.t('kirby.notifications.login')} unless current_kirby_user
      end

      def authorize_admin
        render status: 401 unless current_kirby_user.admin?
      end

    end
  end
end
