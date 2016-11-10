class SprintsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_sprint, only: [:add_user, :remove_user, :edit, :update, :closing, :close, :daily_meetings, :create_daily_meeting]
  before_action :load_user, only: [:add_user, :remove_user]
  before_action :load_sprint_report_texts, only: [:closing, :edit]

  authorize_actions_for Sprint, except: [:edit, :daily_meetings]
  authority_actions add_user: 'update', remove_user: 'update', closing: 'update', close: 'update', create_daily_meeting: 'update'

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

  def daily_meetings
    @today = Date.today

    daily_meetings = @sprint.daily_meetings.all

    @sprint_days = @sprint.sprint_days.map do |day|
      daily_meeting = daily_meetings.find {|dm| dm.date == day }

      sprint_day =
        if daily_meeting
          {
            date: day,
            daily_meeting_present: true,
            daily_meeting_done: daily_meeting.done,
            daily_meeting_skipped: daily_meeting.skip,
            daily_meeting_not_done_reason: daily_meeting.reason
          }
        else
          {
            date: day
          }
        end

      if sprint_day[:date] > @today
        sprint_day[:html_class] = 'sprintfy-daily-meeting-disabled'
      elsif sprint_day[:daily_meeting_skipped]
        sprint_day[:html_class] = 'sprintfy-daily-meeting-skipped'
      elsif sprint_day[:daily_meeting_done]
        sprint_day[:html_class] = 'sprintfy-daily-meeting-done'
      elsif !sprint_day[:daily_meeting_done] && sprint_day[:daily_meeting_present]
        sprint_day[:html_class] = 'sprintfy-daily-meeting-not-done'
      else
        sprint_day[:html_class] = 'sprintfy-daily-meeting-incomplete'
      end

      sprint_day
    end
  end

  def create_daily_meeting
    daily_meeting_date = DateParser::parse_date_string(daily_meeting_params[:date])

    if !@sprint.daily_meetings.where(date: daily_meeting_date).present?
      DailyMeeting.create(
        date: daily_meeting_date,
        done: daily_meeting_params[:done],
        skip: daily_meeting_params[:skip],
        reason: daily_meeting_params[:reason],
        sprint_id: @sprint.id,
        squad_id: @sprint.squad_id
      )
    end

    redirect_to daily_meetings_sprint_path(id: @sprint.id)
  end

  private

  def sprint_params
    params.require(:sprint).permit([:start_date, :due_date, :squad_id])
  end

  def users_params
    params.require(:users)
  end

  def daily_meeting_params
    params.require(:daily_meeting).permit([:date, :done, :skip, :reason])
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
