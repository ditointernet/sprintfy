class Report
  def data_route(params)
      {
        name: "Sp #{user_scope(params)} #{period_scope(params)}",
        period: params[:period],
        data: ChartData.new.config(params)
      }
  end

  def user_scope(params)
    if(params[:user] == 'Todos')
      return 'de todos os usuários'
    elsif (params[:user] == 'Equipe')
      return "da equipe #{squad_name(params[:squad])}"
    else
      return "do usuário #{person_name(params[:person])}"
    end
  end

  def period_scope(params)
    if(params[:period] == 'Sprint')
      return 'por sprint'
    elsif (params[:period] == 'Mensal')
      return "no período de 3 meses"
    else
      return "nas últimas 16 semanas"
    end
  end

  def squad_name(id)
    Squad.where(id: id).first.name
  end

  def person_name(id)
    User.where(id: id).first.name
  end
end
