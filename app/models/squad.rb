class Squad < ApplicationRecord
  include Authority::Abilities
  resourcify

  has_many :users
  has_many :sprints
end
