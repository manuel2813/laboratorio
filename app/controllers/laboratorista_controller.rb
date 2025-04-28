class LaboratoristaController < ApplicationController
  before_action :authenticate_user!
  before_action :verificar_laboratorista

  def dashboard
    # Puedes cargar datos aquí si necesitas, como muestras asignadas
  end

  private

  def verificar_laboratorista
    redirect_to root_path, alert: "Acceso no autorizado." unless current_user&.laboratorista?
  end
end
