class ReportsController < ApplicationController
  before_action :authenticate_user!

  def index
    @report = Report.new
    @data_month_all = @report.chart_data_month_all

    @data_sprint_squad = @report.chart_data_sprint_squad(1)
    @data_month_squad = @report.chart_data_month_squad(1)
    @data_week_squad = @report.chart_data_week_squad(1)

    # @data_sprint_individual = @report.chart_data_sprint_individual(1)
    # @data_month_individual = @report.chart_data_month_individual(1)
    # @data_week_individual = @report.chart_data_week_individual(1)
  end
end
