require 'active_support/concern'

module Kirby
  module Optionable
    extend ActiveSupport::Concern

    included do
      attr_accessor :options
    end

  end
end
