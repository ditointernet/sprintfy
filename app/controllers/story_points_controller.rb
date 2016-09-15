class StoryPointsController < ApplicationController
  before_action :load_sprint, only: [:edit_expected]


  def edit_expected
    users_params.each do |user_params|
      user_params.permit([:id, :story_points])

      user = User.find(user_params[:id])
      @sprint.update_user_expected_story_points(user, user_params[:story_points])
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
