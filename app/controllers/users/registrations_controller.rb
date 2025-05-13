class Users::RegistrationsController < Devise::RegistrationsController
  def create
    build_resource(sign_up_params)

    # Asigna manualmente código de verificación y desactiva el login automático
    resource.verification_code = rand(100000..999999).to_s
    resource.verified = false

    if resource.save
      resource.send_verification_email if resource.email_domain_allowed?

      # No inicia sesión automáticamente
      redirect_to verificacion_path, notice: 'Se ha enviado un código de verificación a tu correo.'
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  private

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation, :role, :tipo_cliente_id)
  end

  def account_update_params
    params.require(:user).permit(:email, :password, :password_confirmation, :current_password)
  end
end
