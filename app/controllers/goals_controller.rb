class GoalsController < ApplicationController
  before_action :load_goal, only: [:destroy, :mark_as_complete]

  authorize_actions_for Goal
  authority_actions mark_as_complete: 'update'

  def create
    @goal = Goal.new(goals_params.merge(completed: false))

    unless @goal.save
      flash[:error] = 'Não foi possível adicionar o goal'
    end

    redirect_to_edit_sprint_path
  end

  def destroy
    @goal.destroy
    redirect_to_edit_sprint_path
  end

  def mark_as_complete
    @goal.update_attribute(:completed, true)
    redirect_to_edit_sprint_path
  end

  private

  def goals_params
    params.require(:goal).permit([:description, :sprint_id, :url])
  end

  def load_goal
    @goal = Goal.find(params.require(:id))
  end

  def redirect_to_edit_sprint_path
    redirect_to edit_sprint_path(id: @goal.sprint_id)
  end
end
