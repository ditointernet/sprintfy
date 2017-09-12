class ReportsController < ApplicationController
  before_action :authenticate_user!

  def index
    @report = Report.new
    @data = @report.chart_data_month_all
    if(params[:group])
      @data = @report.data_route(params[:period],params[:group],params[:squad][:squad_id])
    end
  end
end
