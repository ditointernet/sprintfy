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
    goal = find_goal
    goal.delete

    redirect_to edit_sprint_path(id: goal.sprint_id)
  end

  def mark_as_complete
    goal = find_goal
    goal.completed = true
    goal.save

    redirect_to edit_sprint_path(id: goal.sprint_id)
  end

  private

  def find_goal
    goal = Goal.find(params.require(:id))
  end
end
