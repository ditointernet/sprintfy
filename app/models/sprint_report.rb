class SprintReport < ApplicationRecord
  include Authority::Abilities
  resourcify

  belongs_to :sprint
end
