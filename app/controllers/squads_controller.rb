class SquadsController < ApplicationController
  def new
    @squad = Squad.new
  end

  def create
    squad = Squad.new(params.require(:squad).permit(:name))

    if squad.save
      flash[:notice] = "Equipe #{squad.name} criada!"
      redirect_to :new_squad
    else
      flash[:error] = "Não foi possível criar a equipe"
      redirect_to :new_squad
    end
  end
end
