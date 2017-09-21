class ReportsController < ApplicationController
  before_action :authenticate_user!

  def index
    @data = Report.new(params[:filter]).chart
    @filters = @data[:filters]
  end
end
