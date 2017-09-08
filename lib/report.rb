class Report
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

  def chart_data_month_all
    [
      name: 'SP per month on every user',
      data: chart_data_month_all_data
    ]
  end

  def chart_data_sprint_squad(squad_id)
    [
      name: 'SP per sprint on squad',
      data: chart_data_sprint_squad_data(squad_id)
    ]
  end

  def chart_data_month_all_data
    data_board = {}
      12.times do |i|
        data_board[Date.today.months_ago(11-i).strftime('%b')] = sp_month(Date.today.months_ago(11-i))
      end
    data_board
  end

  def sp_month(date_month)
    total = 0
    Sprint.where('extract(month from due_date) = ?', date_month.month).where('extract(year from due_date) = ?', date_month.year).find_each do |sprint|
      StoryPoint.where(sprint_id: sprint.id).each do |sp|
        total += sp.value if sp.present?
      end
    end
    total
  end

  def chart_data_sprint_squad_data(squad_id)
    data_board = {}
    Sprint.where(squad_id: squad_id).find_each do |sprint|
      data_board[sprint.squad_counter] = sprint.story_points_sprint_squad(sprint.id).to_f
    end
    data_board
  end
end
