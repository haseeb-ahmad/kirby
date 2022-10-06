module Kirby
  class SitemapsController < Kirby::ApplicationController
    def show
      I18n.locale = I18n.default_locale
      @pages = Page.live.sorted
    end
  end
end
