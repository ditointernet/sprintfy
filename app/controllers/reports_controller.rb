class ReportsController < ApplicationController
  before_action :authenticate_user!

  def index
      @report = Report.create
      @test_data = @report.admin_chart_data
      render 'report'
  end
end
