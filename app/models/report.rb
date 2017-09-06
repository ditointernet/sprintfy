class Report < ApplicationRecord
  has_and_belongs_to_many :sprints

  def chart_data_sprint
    sprints_test = {}
    Sprint.find_each do |sprint|
      sprints_test[sprint.id] = {
        squad_name: Squad.where(id: sprint.squad_id).first.name,
        squad_id: sprint.squad_id,
        sprint_start_date: sprint.start_date.strftime("%d-%m-%y"),
        sprint_due_date: sprint.due_date.strftime("%d-%m-%y"),
        sp_total: story_points_sprint_total(sprint.id)
      }
    end
    sprints_test
  end

  def admin_chart_data
    [
      name: 'Test data',
      data: chart_data_sprint
    ]
  end

  def story_points_sprint_total(sprint_id)
    total = 0
    StoryPoint.where(sprint_id: sprint_id).each do |sp|
      total += sp.value if sp.present?
    end
    total
  end
end
