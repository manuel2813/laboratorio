class VerificationsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email])

    if user&.verification_code == params[:codigo]
      user.update(verified: true)
      sign_in(user)
      redirect_to servicios_path, notice: '¡Cuenta verificada correctamente!'
    else
      flash.now[:alert] = 'Código incorrecto o correo no válido.'
      render :new
    end
  end
end
