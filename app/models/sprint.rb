class Sprint < ApplicationRecord
  belongs_to :squad
  has_and_belongs_to_many :users, -> { uniq }
  has_many :goals
  has_many :story_points

  def self.create_for_squad(start_date, due_date, squad)
    Sprint.create(start_date: start_date, due_date: due_date, squad: squad) do |sprint|
      Sprint.transaction do
        squad.users.each do |user|
          sprint.add_user(user)
        end
      end
    end
  end

  def add_user(user)
    self.users.append(user)

    user_story_point = StoryPoint.create(sprint: self, user: user)
    self.story_points.append(user_story_point)
  end

  def remove_user(user)
    self.users.delete(user)
    StoryPoint.where(user: user, sprint: self).destroy_all
  end

  def update_user_expected_story_points(user, points)
    self.story_points.where(user: user).update(expected_value: points)
  end
end
