class SprintsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_sprint, only: [:add_user, :remove_user, :edit, :update, :closing, :close]
  before_action :load_user, only: [:add_user, :remove_user]
  before_action :load_sprint_report_texts, only: [:closing, :edit]

  authorize_actions_for Sprint, except: [:edit]
  authority_actions add_user: 'update', remove_user: 'update', closing: 'update', close: 'update'

  def new
    @sprint = Sprint.new
    @squads = Squad.order(name: :asc)
    @user_squad = current_user.squad_id
    @squads_what_to_change_texts = {}

    @squads.each do |squad|
      last_sprint = squad.sprints.where(closed: true).order(squad_counter: :desc).first

      if last_sprint
        @squads_what_to_change_texts[squad.id] = {
          sprint_number: last_sprint.squad_counter,
          text: last_sprint.report_text('what_to_change')
        }
      end
    end
  end

  def create
    start_date = DateParser::parse_date_string(sprint_params[:start_date])
    due_date = DateParser::parse_date_string(sprint_params[:due_date])

    squad = Squad.find(sprint_params[:squad_id])
    sprint = Sprint.create_for_squad(start_date, due_date, squad)

    if sprint.id
      redirect_to action: :edit, id: sprint.id
    else
      flash[:error] = 'Não foi possível criar o Sprint'
      redirect_to :new_sprint
    end
  end

  def edit
    @sprint_goal = Goal.new(sprint: @sprint)
    @users = User.all.sort {|a, b| a.name_or_email.downcase <=> b.name_or_email.downcase }
  end

  def update
    start_date = DateParser::parse_date_string(sprint_params[:start_date])
    due_date = DateParser::parse_date_string(sprint_params[:due_date])

    @sprint.update_columns(start_date: start_date, due_date: due_date)

    redirect_to_edit_sprint_path
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

    SprintReport.create(did_right_sprint_report_params.merge(name: 'did_right', sprint: @sprint))
    SprintReport.create(did_wrong_sprint_report_params.merge(name: 'did_wrong', sprint: @sprint))
    SprintReport.create(what_to_change_sprint_report_params.merge(name: 'what_to_change', sprint: @sprint))

    @sprint.update(closed: true)

    redirect_to_edit_sprint_path
  end

  private

  def sprint_params
    params.require(:sprint).permit([:start_date, :due_date, :squad_id])
  end

  def users_params
    params.require(:users)
  end

  def did_right_sprint_report_params
    params.require(:did_right_sprint_report).permit([:text])
  end

  def did_wrong_sprint_report_params
    params.require(:did_wrong_sprint_report).permit([:text])
  end

  def what_to_change_sprint_report_params
    params.require(:what_to_change_sprint_report).permit([:text])
  end

  def load_sprint
    id = params[:sprint_id] || params[:id]
    @sprint = Sprint.find(id)
  end

  def load_user
    @user = User.find(params[:user_id])
  end

  def load_sprint_report_texts
    @did_right_text = @sprint.report_text('did_right')
    @did_wrong_text = @sprint.report_text('did_wrong')
    @what_to_change_text = @sprint.report_text('what_to_change')
  end

  def redirect_to_edit_sprint_path
    redirect_to edit_sprint_path(@sprint.id)
  end
end
