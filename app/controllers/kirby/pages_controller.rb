module Kirby
  class PagesController < Kirby::ApplicationController
    include Kirby::Frontend

    before_action :current_kirby_user_can_view_page?, except: [:robots]

    helper_method :page

    def homepage
      render_with_template(page)
    end

    private

    def current_kirby_user_can_view_page?
      raise ActiveRecord::RecordNotFound if page.nil? || !page.live?

      current_kirby_user.present?
    end

  end
end
