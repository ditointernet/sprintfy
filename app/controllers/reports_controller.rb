class ReportsController < ApplicationController
  before_action :authenticate_user!

  def index
    @filters = params[:filter] || {:user => 'Todos',:period => 'Mensal',:squad => 0, :person => 0}
    @report = Report.new
    @data = @report.data_route(@filters)
  end
end
