class SquadsController < ApplicationController
  before_action :authenticate_user!

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
end
