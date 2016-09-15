class Users::PagesController < ApplicationController
  before_action :authenticate_user!

  def sprints
    @sprints = current_user.sprints.order(start_date: :desc)
  end

  def list
    @users = User.order(name: :asc)
  end
end
