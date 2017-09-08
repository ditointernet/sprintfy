class Report < ApplicationRecord
  has_and_belongs_to_many :sprints

  def chart_data_sprint ##testes
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

  def admin_chart_data ##testes
    [
      name: 'Test data',
      data: chart_data_sprint
    ]
  end

  def chart_data_sprint_all
    [
      name: 'SP per sprint on every user',
      data: chart_data_sprint_all_data
    ]
  end

  def chart_data_sprint_squad(squad_id)
    [
      name: 'SP per sprint on squad',
      data: chart_data_sprint_squad_data(squad_id)
    ]
  end

  def chart_data_sprint_all_data
    data_board = {}
    Sprint.find_each do |sprint|
      data_board[sprint.squad_counter] = story_points_sprint_total(sprint.squad_counter).to_f
    end
    data_board
  end

  def chart_data_sprint_squad_data(squad_id)
    data_board = {}
    Sprint.where(squad_id: squad_id).find_each do |sprint|
      data_board[sprint.squad_counter] = story_points_sprint_total(sprint.squad_counter).to_f
    end
    data_board
  end

  def story_points_sprint_total(sprint_squad_counter)
    total = 0
    Sprint.where(squad_counter: sprint_squad_counter).find_each do |sprint|
      StoryPoint.where(sprint_id: sprint.id).each do |sp|
        total += sp.value if sp.present?
      end
    end
    total
  end
end
