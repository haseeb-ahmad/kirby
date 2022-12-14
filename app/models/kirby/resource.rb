module Kirby
  class Resource < ApplicationRecord
    has_many :pages, dependent: :restrict_with_exception

    belongs_to :parent_page, class_name: "Kirby::Page", optional: true

    def pages
      case order_by
      when "title"
        super.joins(:translations).where(kirby_page_translations: {locale: I18n.locale}).order("kirby_page_translations.title")
      else
        super.order(created_at: :desc)
      end
    end
  end
end
