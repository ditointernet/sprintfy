class Users::PagesController < ApplicationController
  before_action :authenticate_user!

  def sprints
    @sprints = current_user.sprints.order(squad_counter: :desc)
  end
end
