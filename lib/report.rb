class Report
  def chart_data_month_all
    [
      name: 'SP per month on every user',
      data: sprints_story_points_all_users
    ]
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
end
