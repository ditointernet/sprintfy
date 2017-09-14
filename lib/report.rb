class Report
  def data_route(period,group,squad_id)
    if (period == 'sprint')
      if(group == 'everyone')
        return chart_data_month_all
      elsif(group == 'squad')
        return chart_data_sprint_squad(squad_id)
      end
    elsif (period == 'week')
      if (group == 'squad')
        return chart_data_week_squad(squad_id)
      end
    elsif(period == 'month')
      if (group == 'squad')
        return chart_data_month_squad(squad_id)
      end
    end
  end

  def chart_data_month_all
    {
      name: 'SP per month on every user',
      period: 'Month',
      data: sprints_story_points_all_users
    }
  end

  def chart_data_sprint_squad(squad_id)
    {
      name: 'SP per sprint on squad',
      period: 'Sprint',
      data: chart_data_sprint_squad_data(squad_id)
    }
  end

  def chart_data_month_squad(squad_id)
    {
      name: 'SP per month on squad',
      period: 'Month',
      data: chart_data_month_squad_data(squad_id)
    }
  end

  def chart_data_week_squad(squad_id)
    {
      name: 'SP per week on squad',
      period: 'Week',
      data: chart_data_week_squad_data(squad_id)
    }
  end

  def sprints_story_points_all_users
    data = {}
    12.times do |i|
      data[Date.today.months_ago(11-i).strftime('%b%y')] = 0
    end
    Sprint.where("Date(due_date) >= ?", Date.today.months_ago(11)).where("Date(due_date) <= ?", Date.today).find_each do |sprint|
      data[sprint.due_date.strftime('%b%y')] += sprint.story_points_total
    end
    data
  end

  def chart_data_sprint_squad_data(squad_id)
    data_board = {}
    Sprint.where(squad_id: squad_id).find_each do |sprint|
      data_board[sprint.squad_counter] = sprint.story_points_total.to_f
    end
    data_board
  end

  def chart_data_month_squad_data(squad_id)
    data = {}
    12.times do |i|
      data[Date.today.months_ago(11-i).strftime('%b-%y')] = 0
    end
    Sprint.where(squad_id: squad_id).where("Date(due_date) >= ?", Date.today.months_ago(11)).where("Date(due_date) <= ?", Date.today).find_each do |sprint|
      data[sprint.due_date.strftime('%b-%y')] += sprint.story_points_total
    end
    data
  end

  def chart_data_week_squad_data(squad_id)
    data = {}
    12.times do |i|
      data[Date.today.beginning_of_week.weeks_ago(11-i).to_formatted_s(:short)] = 0
    end
    Sprint.where(squad_id: squad_id).where("Date(due_date) >= ?", Date.today.weeks_ago(11)).where("Date(due_date) <= ?", Date.today).find_each do |sprint|
      data[sprint.due_date.beginning_of_week.to_formatted_s(:short)] += sprint.story_points_total
    end
    data
  end
end
