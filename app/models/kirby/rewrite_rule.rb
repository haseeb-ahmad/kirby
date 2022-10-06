module Kirby
  class RewriteRule < ApplicationRecord
    validates :old_path, uniqueness: true
  end
end
