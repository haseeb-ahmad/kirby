module Kirby
  class NavigationItem < ApplicationRecord
    belongs_to :navigation, touch: true
    belongs_to :page

    has_ancestry orphan_strategy: :adopt

    scope :sorted, -> { order('kirby_navigation_items.position') }
    scope :live, -> { joins(:page).where(kirby_pages: {draft: false, active: true}) }
    scope :in_menu, -> { joins(:page).where(kirby_pages: {show_in_menu: true}) }
    scope :active, -> { joins(:page).where(kirby_pages: {active: true}) }

    validates :page, uniqueness: {scope: :navigation}

    delegate :menu_title, :materialized_path, to: :page
  end
end
