class GerenteController < ApplicationController
  before_action :authenticate_user!
  before_action :verificar_gerente

  def dashboard
  end

  private

  def verificar_gerente
    redirect_to root_path, alert: "Acceso denegado" unless current_user.gerente?
  end
end
