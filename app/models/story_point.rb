class StoryPoint < ApplicationRecord
  include Authority::Abilities
  resourcify

  belongs_to :sprint
  belongs_to :user

  validates :sprint, presence: true
  validates :user, presence: true

  scope :by_user_on_sprint, ->(user, sprint) do
    where(user: user, sprint: sprint).take
  end
end
