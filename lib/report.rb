class Report
  def data_route(period,group,squad_id)
    if(group == 'Todos')
      return chart_data_month_all
    elsif (period == 'Sprint')
      if(group == 'Equipe')
        return chart_data_sprint_squad(squad_id)
      end
    elsif (period == 'Semanal')
      if (group == 'Equipe')
        return chart_data_week_squad(squad_id)
      end
    elsif(period == 'Mensal')
      if (group == 'Equipe')
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
    Sprint.where(squad_id: squad_id).last(20).each do |sprint|
      data_board["Sprint " + sprint.squad_counter.to_s] = sprint.story_points_total.to_f
    end
    data_board
  end

  def chart_data_month_squad_data(squad_id)
    data = {}
    12.times do |i|
      data[Date.today.months_ago(11-i).strftime('%b%y')] = 0
    end
    Sprint.where(squad_id: squad_id).where("Date(due_date) >= ?", Date.today.months_ago(11)).where("Date(due_date) <= ?", Date.today).find_each do |sprint|
      data[sprint.due_date.strftime('%b%y')] += sprint.story_points_total
    end
    data
  end

  def chart_data_week_squad_data(squad_id)
    data = {}
    Sprint.where(squad_id: squad_id).where("Date(due_date) >= ?", Date.today.weeks_ago(15)).where("Date(due_date) <= ?", Date.today).find_each do |sprint|
      if (data[sprint.due_date.beginning_of_week.strftime('%d/%b/%Y')])
        data[sprint.due_date.beginning_of_week.strftime('%d/%b/%Y')] += sprint.story_points_total
      else
        data[sprint.due_date.beginning_of_week.strftime('%d/%b/%Y')] = sprint.story_points_total
      end
    end
    data
  end
end
