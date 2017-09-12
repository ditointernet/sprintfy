class ReportsController < ApplicationController
  before_action :authenticate_user!

  def index
    @report = Report.new
    if (params[:period] == 'sprint')
      if(params[:group] == 'everyone')
        @data = @report.chart_data_month_all
      elsif(params[:group] == 'squad')
        @data = @report.chart_data_sprint_squad(params[:squad])
      end
    elsif (params[:period] == 'week')
      if (params[:group] == 'squad')
        @data = @report.chart_data_week_squad(params[:squad])
      end
    elsif(params[:period] == 'month')
      if (params[:group] == 'squad')
        @data = @report.chart_data_month_squad(params[:squad])
      end
    end
  end
end
