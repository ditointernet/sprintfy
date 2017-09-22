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

  def total_sprint_days
    self.sprints.map(&:sprint_days).map(&:count).reduce(:+)
  end

  def average_sps_per_sprint
    sprints.each_with_object({}) do |sprint, sps_per_sprint|
      sprint_name = "#{sprint.squad.name}_#{sprint.squad_counter}".tr(' ', '_')
      story_points = self.story_points_on_sprint(sprint).value
      sps_per_sprint[sprint_name] = (story_points/(sprint.total_sprint_days.nonzero? || 1)).to_f
    end
  end

  def personal_evolution_chart_data
    [
      name: 'Média de SPs por dia por sprint',
      data: average_sps_per_sprint
    ]
  end

  def story_points_on_sprint(sprint)
    self.story_points.where(sprint_id: sprint.id).take
  end

  def squad_name
    self.squad.try(:name) || "No squad"
  end

  private

  def assign_default_role
    self.add_role(:user)
  end
end
