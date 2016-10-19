class Users::RegistrationsController < ApplicationController
  before_action :authenticate_user!

  def edit
    @user = current_user
  end

  def update
    @user = current_user

    if @user.update_with_password(user_params)
      bypass_sign_in(@user)
      flash[:notice] = 'Senha alterada!'
    else
      flash[:error] = 'Não foi possível alterar a senha :('
    end

    redirect_to edit_user_registration_path
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation, :current_password)
  end
end
