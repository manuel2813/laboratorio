class ServiciosController < ApplicationController
  before_action :set_servicio, only: %i[ show edit update destroy ]
  before_action :authenticate_user!
  before_action :authorize_gerente, only: %i[new edit create update destroy]  # Solo los gerentes pueden crear, editar y destruir
  before_action :authorize_laboratorista, only: [:show]  # Solo los laboratoristas pueden ver los detalles del servicio

  # GET /servicios or /servicios.json
  def index
    if current_user.cliente?
      @servicios = Servicio.all # Los clientes ven todos los servicios disponibles
    elsif current_user.laboratorista?
      @servicios = Servicio.includes(:compras) # Los laboratoristas también ven los servicios y las compras asociadas
    else
      # Si eres gerente, ves todo
      @servicios = Servicio.all
    end
  end

  # GET /servicios/1 or /servicios/1.json
  def show
    # Mostrar detalles del servicio, solo si eres cliente o laboratorista
    @compras = Compra.where(servicio_id: @servicio.id) if current_user.laboratorista?
  end

  # GET /servicios/new
  def new
    @servicio = Servicio.new
  end

  # POST /servicios or /servicios.json
  def create
    @servicio = Servicio.new(servicio_params)

    respond_to do |format|
      if @servicio.save
        format.html { redirect_to @servicio, notice: "Servicio creado correctamente." }
        format.json { render :show, status: :created, location: @servicio }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @servicio.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /servicios/1 or /servicios/1.json
  def update
    respond_to do |format|
      if @servicio.update(servicio_params)
        format.html { redirect_to @servicio, notice: "Servicio actualizado correctamente." }
        format.json { render :show, status: :ok, location: @servicio }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @servicio.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /servicios/1 or /servicios/1.json
  def destroy
    @servicio.destroy
    respond_to do |format|
      format.html { redirect_to servicios_path, status: :see_other, notice: "Servicio eliminado correctamente." }
      format.json { head :no_content }
    end
  end

  private

  # Filtra los servicios por id o permisos de roles
  def set_servicio
    @servicio = Servicio.find(params[:id])
  end

  # Solo permitir a los gerentes la creación, edición y eliminación de servicios
  def authorize_gerente
    redirect_to root_path, alert: 'Acceso restringido a los gerentes.' unless current_user&.gerente?
  end

  # Solo permitir a los laboratoristas ver los servicios
  def authorize_laboratorista
    redirect_to root_path, alert: 'Acceso restringido a los laboratoristas.' unless current_user&.laboratorista?
  end

  # Permite solo ciertos parámetros para evitar asignaciones masivas
  def servicio_params
    params.require(:servicio).permit(:codigo_servicio, :nombre, :descripcion, :costo_base, :laboratorista_id, :imagen_archivo)
  end
end
