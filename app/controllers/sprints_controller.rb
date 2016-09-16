class SprintsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_sprint, only: [:add_user, :remove_user, :edit, :closing, :close]
  before_action :load_user, only: [:add_user, :remove_user]


  def new
    @sprint = Sprint.new
    @squads = Squad.order(name: :asc)
  end

  def create
    start_date = DateParser::parse_date_string(sprint_params[:start_date])
    due_date = DateParser::parse_date_string(sprint_params[:due_date])

    squad = Squad.find(sprint_params[:squad_id])
    sprint = Sprint.create_for_squad(start_date, due_date, squad)

    if sprint.save
      redirect_to action: :edit, id: sprint.id
    else
      flash[:error] = 'Não foi possível criar o Sprint'
      redirect_to :new_sprint
    end
  end

  def edit
    @sprint_goal = Goal.new(sprint: @sprint)
    @users = User.all
  end

  def add_user
    @sprint.add_user(@user)
    redirect_to_edit_sprint_path
  end

  def remove_user
    @sprint.remove_user(@user)
    redirect_to_edit_sprint_path
  end

  def closing
  end

  def close
    users_params.each do |user_params|
      user_params.permit([:id, :story_points])

      user = User.find(user_params[:id])
      @sprint.update_user_story_points(user, user_params[:story_points])
    end

    redirect_to_edit_sprint_path
  end

  private

  def sprint_params
    params.require(:sprint).permit([:start_date, :due_date, :squad_id])
  end

  def users_params
    params.require(:users)
  end

  def load_sprint
    id = params[:sprint_id] || params[:id]
    @sprint = Sprint.find(id)
  end

  def load_user
    @user = User.find(params[:user_id])
  end

  def redirect_to_edit_sprint_path
    redirect_to edit_sprint_path(@sprint.id)
  end
end
