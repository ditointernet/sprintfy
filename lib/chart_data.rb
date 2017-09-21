# Usar scope. Ex: Sprint.by_squad(squad).after_date(DATA).before_date(DATA).find_each do |sprint|
# Arrumar ternario
# Remover redundancia
# scope :by_squad, (squad_id) -> {
#   if squad_id
#     where(squad_id: squad_id)
#   end
# }
class ChartData
  def config(params)
    @data = {}
    if(params[:user] == 'Todos')
      return data_all_users
    elsif (params[:period] == 'Sprint')
      return data_sprint(params)
    elsif (params[:period] == 'Semanal')
      return data_week(params)
    elsif(params[:period] == 'Mensal')
      return data_month(params)
    end
  end

  def data_all_users
    12.times do |i|
      @data[Date.today.months_ago(11-i).strftime('%b%y')] = 0
    end
    Sprint.where("Date(due_date) >= ?", Date.today.months_ago(11)).where("Date(due_date) <= ?", Date.today).find_each do |sprint|
      @data[sprint.due_date.strftime('%b%y')] += sprint.story_points_total
    end
    @data
  end

  def data_sprint(params)
    params[:squad] ? squad = params[:squad] : squad = Squad.where(id: User.where(id: params[:person]).first.squad_id).first.id
    Sprint.where(squad_id: squad).last(20).each do |sprint|
      @data["Sprint " + sprint.squad_counter.to_s] = sprint.sp_scope(params).to_f
    end
    @data
  end

  def data_month(params)
    params[:squad] ? squad = params[:squad] : squad = Squad.where(id: User.where(id: params[:person]).first.squad_id).first.id
    12.times do |i|
      @data[Date.today.months_ago(11-i).strftime('%b%y')] = 0
    end
    Sprint.where(squad_id: squad).where("Date(due_date) >= ?", Date.today.months_ago(11)).where("Date(due_date) <= ?", Date.today).find_each do |sprint|
      @data[sprint.due_date.strftime('%b%y')] += sprint.sp_scope(params).to_f
    end
    @data
  end

  def data_week(params)
    params[:squad] ? squad = params[:squad] : squad = Squad.where(id: User.where(id: params[:person]).first.squad_id).first.id
    Sprint.where(squad_id: squad).where("Date(due_date) >= ?", Date.today.weeks_ago(15)).where("Date(due_date) <= ?", Date.today).find_each do |sprint|
      if (@data[sprint.due_date.beginning_of_week.strftime('%d/%b/%Y')])
        @data[sprint.due_date.beginning_of_week.strftime('%d/%b/%Y')] += sprint.sp_scope(params)
      else
        @data[sprint.due_date.beginning_of_week.strftime('%d/%b/%Y')] = sprint.sp_scope(params)
      end
    end
    @data
  end
end
