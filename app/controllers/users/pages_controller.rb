class Users::PagesController < ApplicationController
  before_action :authenticate_user!

  def new_user
    @user = User.new
    @squads = Squad.order(name: :asc)
  end

  def create_user
    @user = User.new(user_params)

    if @user.save
      flash[:notice] = 'Usuário criado!'
    else
      flash[:error] = 'Não foi possível criar o usuário.'
    end

    redirect_to_new_user_path
  end

  def sprints
    @sprints = current_user.sprints.order(start_date: :desc)
  end

  def list
    @users = User.order(name: :asc)
  end

  private

  def user_params
    params.require(:user).permit([:email, :name, :password, :squad_id])
  end

  def redirect_to_new_user_path
    redirect_to new_user_path
  end
end
