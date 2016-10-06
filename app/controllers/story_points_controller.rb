class StoryPointsController < ApplicationController
  before_action :load_sprint, only: [:update]

  authorize_actions_for StoryPoint

  def update
    users_params.each do |user_params|
      user_params.permit([:id, :story_points, :expected_story_points])

      user = User.find(user_params[:id])

      if user_params[:expected_story_points]
        @sprint.update_user_expected_story_points(user, user_params[:expected_story_points])
      end

      if user_params[:story_points]
        @sprint.update_user_story_points(user, user_params[:story_points])
      end
    end

    redirect_to_edit_sprint_path
  end

  private

  def sprint_params
    params.require(:sprint).permit(:id)
  end

  def users_params
    params.require(:users)
  end

  def load_sprint
    @sprint = Sprint.find(sprint_params[:id])
  end

  def redirect_to_edit_sprint_path
    redirect_to edit_sprint_path(@sprint.id)
  end
end
