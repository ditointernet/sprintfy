class ReportsController < ApplicationController
  before_action :authenticate_user!

  def index
    @report = Report.new
    @month_all_data = @report.chart_data_month_all
  end
end
