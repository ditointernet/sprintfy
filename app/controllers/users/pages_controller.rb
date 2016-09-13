class Users::PagesController < ApplicationController
  def sprints
    @sprints = current_user.sprints.order(start_date: :desc)
  end
end
