class ReportsController < ApplicationController
  before_action :authenticate_user!

  def index
    @report = Report.create
    @sprint_all_data = @report.chart_data_sprint_all
    @sprint_squad_data = @report.chart_data_sprint_squad(1)
    render 'report'
  end
end
