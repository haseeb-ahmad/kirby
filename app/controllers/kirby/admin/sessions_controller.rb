module Kirby
  module Admin
    class SessionsController < AdminController

      layout 'kirby/login'

      skip_before_action :authorize_kirby_user

      def new
      end

      def create
        user = User.where(email: params[:email]).first
        if user && user.authenticate(params[:password])
          session[:user_id] = user.id
          user.update_last_logged_in!
          redirect_to kirby.admin_root_url
        else
          flash.now[:alert] = I18n.t('kirby.notifications.wrong_username_or_password')
          render :new
        end
      end

      def destroy
        session[:user_id] = nil
        redirect_to "/"
      end
    end
  end
end
