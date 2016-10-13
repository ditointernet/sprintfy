class Users::PagesController < ApplicationController
  before_action :authenticate_user!

  def new_user
    @user = User.new
    @squads = Squad.order(name: :asc)
    @roles = Role.order(name: :asc).to_a

    if user_role = @roles.find {|r| r.name == 'user' }
      @default_role_id = user_role.id
    end
  end

  def create_user
    @user = User.new(user_params)

    if @user.save
      role = Role.find(role_params)
      @user.add_role(role.name)

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

  def role_params
    params[:role]
  end

  def redirect_to_new_user_path
    redirect_to new_user_path
  end
end
