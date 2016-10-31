class StoryPoint < ApplicationRecord
  include Authority::Abilities
  resourcify

  belongs_to :sprint
  belongs_to :user

  validates :sprint, presence: true
  validates :user, presence: true
end
