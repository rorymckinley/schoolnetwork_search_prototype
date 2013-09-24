class Site < ActiveRecord::Base
  validates :name, uniqueness: true
end
