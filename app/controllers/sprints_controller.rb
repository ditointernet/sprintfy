class SprintsController < ApplicationController
  before_action :authenticate_user!

  def new
    @sprint = Sprint.new
    @squads = Squad.order(name: :asc)
  end

  def create
    sprint_params = params.require(:sprint).permit([:start_date, :due_date, :squad_id])

    # Faz o parse das datas do sprint
    start_date = DateParser::parse_date_string(sprint_params[:start_date])
    due_date = DateParser::parse_date_string(sprint_params[:due_date])

    # Cria o sprint e adiciona usuários da equipe do sprint
    squad = Squad.find(sprint_params[:squad_id])
    sprint = Sprint.new_for_squad(start_date, due_date, squad)

    if sprint.save
      redirect_to action: :edit, id: sprint.id
    else
      flash[:error] = 'Não foi possível criar o Sprint'
      redirect_to :new_sprint
    end
  end

  def edit
    @sprint = Sprint.find(params[:id])
    @sprint_goal = Goal.new(sprint: @sprint)

    # TODO:
    # Poderia ser feito paginado e apenas quando o usuário decidisse
    # adicionar um novo participante no Sprint.
    @users = User.all
  end

  def add_user
    sprint_id = params.require(:sprint_id)
    user_id = params.require(:user_id)

    # Encontra o sprint e adiciona o participante
    begin
      sprint = Sprint.find(sprint_id)
      user = User.find(user_id) # TODO: Precisa buscar do banco mesmo?

      sprint.users.append(user)
    end

    redirect_to edit_sprint_path(sprint_id)
  end

  def remove_user
    sprint_id = params.require(:sprint_id)
    user_id = params.require(:user_id)

    # Encontra o sprint e remove o participante
    begin
      sprint = Sprint.find(sprint_id)
      user = User.find(user_id) # TODO: Tem como deletar da associação sem buscar do banco?

      sprint.users.delete(user)
    end

    redirect_to edit_sprint_path(sprint_id)
  end
end
