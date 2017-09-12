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
      data: sprints_in_year
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

  def sprints_in_year
    data = {}
    12.times do |i|
      data[Date.today.months_ago(11-i).strftime('%b-%y')] = 0
    end
    Sprint.where("Date(due_date) >= ?", Date.today.months_ago(11)).where("Date(due_date) <= ?", Date.today).find_each do |sprint|
      data[sprint.due_date.strftime('%b-%y')] = sprint.story_points_total
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
    data_board = {}
      12.times do |i|
        data_board[Date.today.months_ago(11-i).strftime('%b-%y')] = sp_month_squad(Date.today.months_ago(11-i),squad_id)
      end
    data_board
  end

  def chart_data_week_squad_data(squad_id)
    data_board = {}
      12.times do |i|
        data_board[Date.today.weeks_ago(11-i).to_formatted_s(:short) ] = sp_week_squad(Date.today.weeks_ago(11-i),squad_id)
      end
    data_board
  end

  def sp_month_squad(date_month,squad_id)
    total = 0
    Sprint.where('squad_id = ?',squad_id).where('extract(month from due_date) = ?', date_month.month).where('extract(year from due_date) = ?', date_month.year).find_each do |sprint|
      StoryPoint.where(sprint_id: sprint.id).each do |sp|
        total += sp.value if sp.present?
      end
    end
    total
  end

  def sp_week_squad(date_week,squad_id)
    total = 0
    Sprint.where('squad_id = ?',squad_id).where('extract(year from due_date) = ?', date_week.year).find_each do |sprint|
      if(sprint.due_date.beginning_of_week == date_week.beginning_of_week)
        StoryPoint.where(sprint_id: sprint.id).each do |sp|
          total += sp.value if sp.present?
        end
      end
    end
    total
  end
end
