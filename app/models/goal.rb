class Goal < ApplicationRecord
  include Authority::Abilities
  resourcify

  belongs_to :sprint
end
