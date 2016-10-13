class StoryPoint < ApplicationRecord
  include Authority::Abilities
  resourcify

  belongs_to :sprint
  belongs_to :user

  validates :sprint_id, presence: true
  validates :user_id, presence: true
end
