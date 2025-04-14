class HomeController < ApplicationController
  # Requiere autenticación para todas las acciones excepto las indicadas
  before_action :authenticate_user!, except: [:index, :tutoriales, :servicios]

  skip_before_action :authenticate_user!, only: [:select_role]

  def index
    if user_signed_in?
      # Si el usuario está autenticado, mostrar contenido del Home
      @samples = Sample.all.limit(5)
    else
      # Si no está autenticado, mostrar contenido público
      @public_content = "Bienvenido al Laboratorio Central de la UNAS."
    end
  end

  def tutoriales
    # Lógica para la página de tutoriales
    @tutoriales = ["Tutorial 1: Cómo tomar muestras", "Tutorial 2: Análisis básico", "Tutorial 3: Procedimientos avanzados"]
  end

  def servicios
    # Lógica para la página de servicios
    @servicios = [
      { nombre: "Análisis de suelo", descripcion: "Obtén un reporte completo sobre la calidad de tu suelo." },
      { nombre: "Asesorías especializadas", descripcion: "Consultoría con expertos en investigación de suelos." },
      { nombre: "Muestreo a campo", descripcion: "Servicio de toma de muestras directamente en el lugar de estudio." }
    ]
  end

  def select_role
    role = params[:role]

    case role
    when 'laboratorista', 'admin'
      redirect_to new_user_session_path(role: role) # Redirigir al login estándar
    when 'cliente'
      redirect_to login_client_path # Redirigir al formulario del cliente
    else
      # Manejo de errores para roles no válidos
      flash[:alert] = 'Rol no válido. Por favor, seleccione un rol válido.'
      
      render :select_role # Renderiza la vista nuevamente
    end
  end
end
