class DailyMeetingsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_sprint

  def index
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

      sprint_day[:html_class] = get_sprint_day_class(@today, sprint_day)
      sprint_day
    end
  end

  def create
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

  def daily_meeting_params
    params.require(:daily_meeting).permit([:date, :done, :skip, :reason])
  end

  def load_sprint
    @sprint = Sprint.find(params[:id])
  end

  def get_sprint_day_class(day, sprint_day)
    if sprint_day[:date] > day
      'sprintfy-daily-meeting-disabled'
    elsif sprint_day[:daily_meeting_skipped]
      'sprintfy-daily-meeting-skipped'
    elsif sprint_day[:daily_meeting_done]
      'sprintfy-daily-meeting-done'
    elsif !sprint_day[:daily_meeting_done] && sprint_day[:daily_meeting_present]
      'sprintfy-daily-meeting-not-done'
    else
      'sprintfy-daily-meeting-incomplete'
    end
  end
end
