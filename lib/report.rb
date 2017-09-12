class Report
  def chart_data_month_all
    [
      name: 'SP per month on every user',
      data: chart_data_month_all_data
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
end
