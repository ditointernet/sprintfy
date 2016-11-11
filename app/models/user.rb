class User < ApplicationRecord
  after_commit :assign_default_role

  include Authority::UserAbilities

  belongs_to :squad, optional: true
  has_and_belongs_to_many :sprints, -> { distinct }
  has_many :story_points
  has_many :squad_managers

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  rolify

  def name_or_email
    self.name || self.email
  end

  def admin?
    self.has_role?(:admin)
  end

  def sprinter?
    self.has_role(:sprinter)
  end

  private

  def assign_default_role
    self.add_role(:user)
  end
end
