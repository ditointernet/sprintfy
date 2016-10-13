class Users::PagesController < ApplicationController
  before_action :authenticate_user!

  def new_user
    @user = User.new
    @squads = Squad.order(name: :asc)
    @roles = Role.order(name: :asc)
  end

  def create_user
    @user = User.new(user_params)

    if @user.save
      roles = Role.find(roles_params.to_a)

      roles.each do |role|
        @user.add_role(role.name)
      end

      flash[:notice] = 'Usuário criado!'
    else
      flash[:error] = 'Não foi possível criar o usuário.'
    end

    redirect_to_new_user_path
  end

  def sprints
    query = current_user.admin? ? Sprint : current_user.sprints
    @sprints = query.order(squad_counter: :desc)
  end

  def list
    @users = User.order(name: :asc)
  end

  private

  def user_params
    params.require(:user).permit([:email, :name, :password, :squad_id, :roles])
  end

  def roles_params
    params.require(:roles)
  end

  def redirect_to_new_user_path
    redirect_to new_user_path
  end
end
