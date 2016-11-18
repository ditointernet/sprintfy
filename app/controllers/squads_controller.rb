class SquadsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_squad, only: [:edit, :update]

  def new
    @squad = Squad.new
  end

  def create
    squad = Squad.new(params.require(:squad).permit(:name))

    if squad.save
      flash[:notice] = "Equipe #{squad.name} criada!"
      redirect_to new_squad_path
    else
      flash[:error] = "Não foi possível criar a equipe"
      redirect_to new_squad_path
    end
  end

  def index
    @squads = Squad.order(name: :asc)
  end

  def edit
    @squad_users = @squad.users
    @squad_managers = @squad.squad_managers.map(&:user)
  end

  def update
    if squad_manager_params.present?
      if !SquadManager.where(user_id: squad_manager_params[:id], squad: @squad).present?
        user = User.find(squad_manager_params[:id])
        SquadManager.create(user: user, squad: @squad)
      end
    end

    redirect_to edit_squad_path(@squad)
  end

  private

  def load_squad
    @squad = Squad.find(params[:id])
  end

  def squad_manager_params
    params.require(:squad_manager).permit(:id)
  end
end
