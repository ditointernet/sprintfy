class Report < ApplicationRecord
  has_and_belongs_to_many :sprints

  def chart_data_sprint
    sprints_test = {}
    Sprint.all.each_with_object({}) do |sprint|
      sprints_test[sprint.id] = [
        Squad.where(id: sprint.squad_id).first.name,
        sprint.squad_id,
        sprint.start_date.strftime("%d-%m-%y"),
        sprint.due_date.strftime("%d-%m-%y")
      ]
    end
    sprints_test
  end

    def admin_chart_data
      [
        name: 'Test data',
        data: chart_data_sprint
      ]
    end
end
