class Report
  def data_route(period,group,squad_id,user_id)
    if (period == 'sprint')
      if(group == 'everyone')
        return chart_data_month_all
      elsif(group == 'squad')
        return chart_data_sprint_squad(squad_id)
      elsif (group == 'user')
        return chart_data_sprint_user(user_id)
      end
    elsif (period == 'week')
      if (group == 'squad')
        return chart_data_week_squad(squad_id)
      elsif (group == 'user')
        return chart_data_week_user(user_id)
      end
    elsif(period == 'month')
      if (group == 'squad')
        return chart_data_month_squad(squad_id)
      elsif (group == 'user')
        return chart_data_month_user(user_id)
      end
    end
  end

  def chart_data_month_all
    {
      name: 'SP per month of all users',
      period: 'Month',
      data: sprints_story_points_all_users
    }
  end

  def chart_data_sprint_squad(squad_id)
    {
      name: 'SP per sprint of squad',
      period: 'Sprint',
      data: chart_data_sprint_squad_data(squad_id)
    }
  end

  def chart_data_month_squad(squad_id)
    {
      name: 'SP per month of squad',
      period: 'Month',
      data: chart_data_month_squad_data(squad_id)
    }
  end

  def chart_data_week_squad(squad_id)
    {
      name: 'SP per week of squad',
      period: 'Week',
      data: chart_data_week_squad_data(squad_id)
    }
  end

  def chart_data_sprint_user(user_id)
    {
      name: 'SP per sprint of user',
      period: 'Sprint',
      data: chart_data_sprint_user_data(user_id)
    }
  end

  def chart_data_month_user(user_id)
    {
      name: 'SP per month of user',
      period: 'Month',
      data: chart_data_month_user_data(user_id)
    }
  end

  def chart_data_week_user(user_id)
    {
      name: 'SP per week of user',
      period: 'Week',
      data: chart_data_week_user_data(user_id)
    }
  end

  def sprints_story_points_all_users
    data = {}
    12.times do |i|
      data[Date.today.months_ago(11-i).strftime('%b-%y')] = 0
    end
    Sprint.where("Date(due_date) >= ?", Date.today.months_ago(11)).where("Date(due_date) <= ?", Date.today).find_each do |sprint|
      data[sprint.due_date.strftime('%b-%y')] += sprint.story_points_total
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
    Sprint.where(squad_id: squad_id).where("Date(due_date) >= ?", Date.today.weeks_ago(11)).where("Date(due_date) <= ?", Date.today).find_each do |sprint|
      if (data[sprint.due_date.beginning_of_week.to_formatted_s(:short)])
        data[sprint.due_date.beginning_of_week.to_formatted_s(:short)] += sprint.story_points_total
      else
        data[sprint.due_date.beginning_of_week.to_formatted_s(:short)] = sprint.story_points_total
      end
    end
    data
  end

  def chart_data_sprint_user_data(user_id)
    data_board = {}
    squad = Squad.where(id: User.where(id: user_id).first.squad_id).first
    Sprint.where(squad_id: squad.id).find_each do |sprint|
      data_board[sprint.squad_counter] = sprint.story_points_total_user(user_id).to_f
    end
    data_board
  end

  def chart_data_month_user_data(user_id)
    data = {}
    squad = Squad.where(id: User.where(id: user_id).first.squad_id).first
    12.times do |i|
      data[Date.today.months_ago(11-i).strftime('%b-%y')] = 0
    end
    Sprint.where(squad_id: squad.id).where("Date(due_date) >= ?", Date.today.months_ago(11)).where("Date(due_date) <= ?", Date.today).find_each do |sprint|
      data[sprint.due_date.strftime('%b-%y')] += sprint.story_points_total_user(user_id)
    end
    data
  end

  def chart_data_week_user_data(user_id)
    data = {}
    squad = Squad.where(id: User.where(id: user_id).first.squad_id).first
    Sprint.where(squad_id: squad.id).where("Date(due_date) >= ?", Date.today.weeks_ago(11)).where("Date(due_date) <= ?", Date.today).find_each do |sprint|
      if (data[sprint.due_date.beginning_of_week.to_formatted_s(:short)])
        data[sprint.due_date.beginning_of_week.to_formatted_s(:short)] += sprint.story_points_total_user(user_id)
      else
        data[sprint.due_date.beginning_of_week.to_formatted_s(:short)] = sprint.story_points_total_user(user_id)
      end
    end
    data
  end
end
