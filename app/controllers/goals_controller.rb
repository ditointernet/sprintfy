class GoalsController < ApplicationController
  def create
    goal = Goal.new(params.require(:goal).permit([:description, :sprint_id]))
    goal.completed = false

    unless goal.save
      flash[:error] = 'Não foi possível adicionar o goal'
    end

    redirect_to edit_sprint_path(id: goal.sprint_id)
  end

  def destroy
    goal_id = params.require(:goal_id)

    goal = Goal.find(goal_id)
    goal.delete

    redirect_to edit_sprint_path(id: goal.sprint_id)
  end

  def mark_as_complete
    goal_id = params.require(:goal_id)

    goal = Goal.find(goal_id)
    goal.completed = true
    goal.save

    redirect_to edit_sprint_path(id: goal.sprint_id)
  end
end
