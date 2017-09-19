class ReportsController < ApplicationController
  before_action :authenticate_user!

  def index
    @filters = params[:filter] || {}
    @report = Report.new
    @data = @report.data_route(
      @filters[:period],
      @filters[:user] || 'Todos',
      @filters[:squad],
      @filters[:person]
    )
  end
end
