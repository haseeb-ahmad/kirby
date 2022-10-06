module Kirby
  class Setting < ApplicationRecord

    validates :plugin, presence: true

  end
end
