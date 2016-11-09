class Users::PasswordsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.find_by_email(user_params[:email])

    if @user
      @user.send_reset_password_instructions
      flash[:notice] = 'E-mail de instruções enviado'
      redirect_to :root
    else
      flash[:notice] = 'Usuário não encontrado'
      redirect_to :user_password
    end
  end

  def edit
    @user = User.new
    @reset_password_token = params[:reset_password_token]
  end

  def update
    @user = User.reset_password_by_token(user_params)

    if @user.errors.empty?
      flash[:notice] = 'Senha alterada!'
      redirect_to :root
    else
      if @user.errors.details[:password_confirmation].present?
        flash[:notice] = 'As senhas digitadas devem ser iguais'
        redirect_back_to_change_password
      elsif @user.errors.details[:password].present?
        flash[:notice] = 'A senha deve ter mais de 6 caracteres'
        redirect_back_to_change_password
      else
        flash[:error] = 'Não foi possível alterar a senha'
        redirect_to :root
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :reset_password_token)
  end

  def redirect_back_to_change_password
    redirect_to edit_user_password_path(reset_password_token: user_params[:reset_password_token])
  end
end
