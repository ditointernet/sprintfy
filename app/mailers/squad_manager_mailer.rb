class SquadManagerMailer < ApplicationMailer
  def sprint_report_email(sprint)
    @sprint = sprint
    @squad = @sprint.squad

    @sprint_days_count = @sprint.sprint_days.count

    @complete_goals = @sprint.goals.where(completed: true)
    @incomplete_goals = @sprint.goals.where(completed: false)

    @story_points = @sprint.story_points.map do |story_points|
      user_story_points = story_points.user.story_points.where(sprint: @sprint.previous)

      {
        user_name: story_points.user.name_or_email,
        story_points: story_points.value,
        expected_story_points: story_points.expected_value,
        story_points_average: user_story_points.count == 0 ? 0.0 : 100 * user_story_points.sum(:value) / user_story_points.sum(:expected_value),
        daily_story_points: story_points.value / @sprint_days_count,
        daily_story_points_average: user_story_points.count == 0 ? 0.0 : user_story_points.sum(:value) / story_points.user.total_sprint_days,
        total_percent: story_points.expected_value == 0 ? 0 : (100 * story_points.value / story_points.expected_value)
      }
    end

    @total_story_points = {}
    @total_story_points[:story_points] = @story_points.map {|sp| sp[:story_points] }.reduce(:+)
    @total_story_points[:expected_story_points] = @story_points.map {|sp| sp[:expected_story_points] }.reduce(:+)
    @total_story_points[:story_points_average] = @sprint.squad_counter == 1 ? 0.0 : (100 * @squad.story_points.where(sprint: @sprint.previous).sum(:value) / @squad.story_points.where(sprint: @sprint.previous).sum(:expected_value))
    @total_story_points[:daily_story_points] = @total_story_points[:story_points] / @sprint_days_count
    @total_story_points[:daily_story_points_average] = @sprint.squad_counter == 1 ? 0.0 : @squad.story_points.where(sprint: @sprint.previous).sum(:value) / @sprint.previous.map(&:total_sprint_days).reduce(:+)
    @total_story_points[:total_percent] = @total_story_points[:expected_story_points] == 0 ? 0 : (100 * @total_story_points[:story_points] / @total_story_points[:expected_story_points])

    @sprint_what_to_change = sprint_report_items('what_to_change')
    @sprint_did_right = sprint_report_items('did_right')
    @sprint_did_wrong = sprint_report_items('did_wrong')

    recipients = @squad.squad_managers.map do |manager|
      manager.user.email
    end

    subject = "Relatório Sprint \##{@sprint.squad_counter} - Equipe #{@squad.name}"

    mail(to: recipients, subject: subject)
  end

  private

  def sprint_report_items(report_name)
    @sprint.report_text(report_name).split("\n").map(&:strip)
  end
end
