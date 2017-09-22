class Report
  def initialize(filters = nil)
    @filters = filters || default_filters
  end

  def chart
    {
      name: "Sp #{user_group} #{period_scope}",
      period: @filters[:period],
      data: ChartData.new(@filters).data,
      filters: @filters
    }
  end

  private

  def default_filters
    { user: 'Todos', period: 'Mensal', squad: nil, person: nil }
  end

  def user_group
    {
      'Todos' => 'de todos os usuários',
      'Equipe' => "da equipe #{squad_name}",
      'Individual' => "do usuário #{person_name}"
    }[@filters[:user]]
  end

  def period_scope
    {
      'Sprint' => 'por sprint',
      'Mensal' => 'no período de 12 meses',
      'Semanal' => 'nas últimas 16 semanas'
    }[@filters[:period]]
  end

  def squad_name
    Squad.where(id: @filters[:squad]).first.try(:name)
  end

  def person_name
    User.where(id: @filters[:person]).first.try(:name)
  end
end
