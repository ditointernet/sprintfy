class SquadManagerMailer < ApplicationMailer
  def sprint_report_email(sprint)
    @sprint = sprint
    @squad = @sprint.squad

    @sprint_days_count = @sprint.start_date.upto(@sprint.due_date).select(&:on_weekday?).count

    @complete_goals = @sprint.goals.where(completed: true)
    @incomplete_goals = @sprint.goals.where(completed: false)

    @users_story_points = @sprint.story_points.map do |story_points|
      {
        user_name: story_points.user.name_or_email,
        story_points: story_points.value,
        expected_story_points: story_points.expected_value,
        daily_story_points: (story_points.value / @sprint_days_count),
        total_percent: story_points.expected_value == 0 ? 0 : (story_points.value / story_points.expected_value)
      }
    end

    @total_users_story_points = {
      story_points: @users_story_points.map {|sp| sp[:story_points] }.reduce(:+),
      expected_story_points: @users_story_points.map {|sp| sp[:expected_story_points] }.reduce(:+),
    }
    @total_users_story_points[:daily_story_points] = @total_users_story_points[:story_points] / @sprint_days_count
    @total_users_story_points[:total_percent] = @total_users_story_points[:expected_story_points] == 0 ? 0 : (@total_users_story_points[:story_points] / @total_users_story_points[:expected_story_points])

    @sprint_what_to_change = @sprint.report_text('what_to_change').split("\n").map(&:strip)
    @sprint_did_right = @sprint.report_text('did_right').split("\n").map(&:strip)
    @sprint_did_wrong = @sprint.report_text('did_wrong').split("\n").map(&:strip)

    recipients = @squad.squad_managers.map do |manager|
      manager.user.email
    end

    mail(to: recipients, subject: "Relatório Sprint \##{@sprint.squad_counter} - Equipe #{@squad.name}")
  end
end
