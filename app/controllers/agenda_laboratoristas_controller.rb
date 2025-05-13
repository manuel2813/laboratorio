class AgendaLaboratoristasController < ApplicationController
  before_action :set_agenda, only: %i[ show edit update destroy ]
  before_action :authenticate_user!

  # GET /agenda_laboratoristas
  def index
  @agenda_laboratoristas = AgendaLaboratorista
    .where(laboratorista_id: current_user.id)
    .order(:fecha, :hora_inicio)
end

  # GET /agenda_laboratoristas/new
  def new
    @agenda_laboratorista = AgendaLaboratorista.new
  end
  

  # POST /agenda_laboratoristas
  def create
    @agenda = AgendaLaboratorista.new(agenda_params)
    @agenda.laboratorista_id = current_user.id

    if @agenda.save
      redirect_to agenda_laboratoristas_path, notice: "Evento creado correctamente."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # GET /agenda_laboratoristas/:id/edit
  def edit
  end

  # PATCH/PUT /agenda_laboratoristas/:id
  def update
    if @agenda.update(agenda_params)
      redirect_to agenda_laboratoristas_path, notice: "Evento actualizado correctamente."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /agenda_laboratoristas/:id
  def destroy
  @agenda = AgendaLaboratorista.find(params[:id])
  @agenda.destroy

  redirect_to agenda_laboratoristas_path, notice: "Horario eliminado correctamente."
end
  def crear_horarios_multiples
  dias = params[:dias] || []
  hora_inicio_param = Time.parse(params[:hora_inicio])
  hora_fin_param = Time.parse(params[:hora_fin])
  duracion = params[:duracion].to_i
  descripcion = params[:descripcion]
  horarios_creados = 0

  dias.each do |dia|
    fecha = siguiente_fecha_para(dia)
    hora_actual = Time.zone.local(fecha.year, fecha.month, fecha.day, hora_inicio_param.hour, hora_inicio_param.min)
    hora_limite = Time.zone.local(fecha.year, fecha.month, fecha.day, hora_fin_param.hour, hora_fin_param.min)

    while hora_actual < hora_limite
      AgendaLaboratorista.create!(
        laboratorista_id: current_user.id,
        fecha: fecha,
        hora_inicio: hora_actual,
        hora_fin: hora_actual + duracion.minutes,
        descripcion: descripcion
      )
      hora_actual += duracion.minutes
      horarios_creados += 1
    end
  end

  redirect_to agenda_laboratoristas_path, notice: "#{horarios_creados} horarios creados exitosamente."
end
  private
  
  def siguiente_fecha_para(dia_nombre)
    dias = {
      "lunes" => 1, "martes" => 2, "miercoles" => 3,
      "jueves" => 4, "viernes" => 5
    }
  
    hoy = Date.today
    target_day = dias[dia_nombre]
    dias_a_sumar = (target_day - hoy.wday) % 7
    hoy + dias_a_sumar
  end
  
  private
    def set_agenda
      @agenda = AgendaLaboratorista.find(params[:id])
    end

    def agenda_params
      params.require(:agenda_laboratorista).permit(:fecha, :hora_inicio, :hora_fin, :descripcion)
    end
end
