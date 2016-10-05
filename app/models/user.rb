class User < ApplicationRecord
  belongs_to :squad, optional: true
  has_and_belongs_to_many :sprints, -> { distinct }
  has_many :story_points

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  rolify

  def name_or_email
    self.name || self.email
  end
end
