class SquadManagerMailer < ApplicationMailer
  def sprint_report_email(sprint)
    @sprint = sprint
    @squad = @sprint.squad

    @sprint_days_count = @sprint.sprint_days.count

    @complete_goals = @sprint.goals.where(completed: true)
    @incomplete_goals = @sprint.goals.where(completed: false)

    @story_points = @sprint.story_points.map do |story_points|
      user_story_points = story_points.user.story_points.where(sprint: @sprint.closed_before)
      user_story_points_total = user_story_points.sum(:value).to_f
      user_story_points_expected_total = user_story_points.sum(:expected_value).to_f

      {
        user_name: story_points.user.name_or_email,
        story_points: story_points.value,
        expected_story_points: story_points.expected_value,
        story_points_average: safe_div(100 * user_story_points_total, user_story_points_expected_total),
        daily_story_points: safe_div(story_points.value, @sprint_days_count),
        daily_story_points_average: safe_div(user_story_points_total, story_points.user.total_sprint_days - @sprint_days_count),
        total_percent: safe_div(100 * story_points.value, story_points.expected_value)
      }
    end

    @total_story_points = {}
    @total_story_points[:story_points] = @story_points.map {|sp| sp[:story_points] }.sum
    @total_story_points[:expected_story_points] = @story_points.map {|sp| sp[:expected_story_points] }.sum
    @total_story_points[:story_points_average] = safe_div(100 * @squad.story_points.where(sprint: @sprint.previous).sum(:value).to_f, @squad.story_points.where(sprint: @sprint.previous).sum(:expected_value).to_f)
    @total_story_points[:daily_story_points] = safe_div(@total_story_points[:story_points], @sprint_days_count)
    @total_story_points[:daily_story_points_average] = safe_div(@squad.story_points.where(sprint: @sprint.previous).sum(:value).to_f, @sprint.previous.map(&:total_sprint_days).reduce(0, :+))
    @total_story_points[:total_percent] = safe_div(100 * @total_story_points[:story_points], @total_story_points[:expected_story_points])

    @sprint_what_to_change = sprint_report_items('what_to_change')
    @sprint_did_right = sprint_report_items('did_right')
    @sprint_did_wrong = sprint_report_items('did_wrong')

    @daily_meeting_done_count = @sprint.daily_meetings.where(done: true).count
    @daily_meeting_not_done = @sprint.daily_meetings.where(done: false, skip: false)
    @sprint_skipped_days = @sprint.daily_meetings.where(skip: true).count

    managers = @squad.squad_managers.map { |manager| manager.user.email }
    team_members = @squad.users.map(&:email)
    recipients = managers.concat(team_members).uniq

    subject = "Relatório Sprint \##{@sprint.squad_counter} - Equipe #{@squad.name}"

    mail(to: recipients, subject: subject)
  end

  private

  def sprint_report_items(report_name)
    @sprint.report_text(report_name).split("\n").map(&:strip)
  end

  def safe_div(a, b)
    b == 0 ? 0.0 : (a / b)
  end
end
