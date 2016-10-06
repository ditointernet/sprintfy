class StoryPoint < ApplicationRecord
  include Authority::Abilities
  resourcify

  belongs_to :sprint
  belongs_to :user
end
