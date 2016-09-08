class Squad < ApplicationRecord
  has_many :users
  has_many :sprints
end
