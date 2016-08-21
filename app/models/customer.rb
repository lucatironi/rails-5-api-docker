class Customer < ApplicationRecord
  validates_presence_of :full_name
end
