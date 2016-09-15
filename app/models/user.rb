class User < ApplicationRecord
  belongs_to :squad, optional: true
  has_and_belongs_to_many :sprints, -> { uniq }
  has_many :story_points

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def name_or_email
    self.name || self.email
  end
end
