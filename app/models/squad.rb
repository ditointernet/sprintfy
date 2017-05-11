class Squad < ApplicationRecord
  include Authority::Abilities
  resourcify

  has_many :users
  has_many :squad_managers
  has_many :sprints

  def story_points
    StoryPoint.where(sprint: self.sprints)
  end
end
