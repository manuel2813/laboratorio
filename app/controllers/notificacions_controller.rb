class NotificacionsController < ApplicationController
  before_action :authenticate_user!                 # Asegura que el usuario esté logueado
  before_action :authorize_gerente                  # Solo el gerente puede acceder
  before_action :set_notificacion, only: %i[show edit update destroy]

  # GET /notificacions
  def index
    @notificacions = Notificacion.all
  end

  # GET /notificacions/1
  def show
  end

  # GET /notificacions/new
  def new
    @notificacion = Notificacion.new
  end

  # GET /notificacions/1/edit
  def edit
  end

  # POST /notificacions
  def create
    @notificacion = Notificacion.new(notificacion_params)

    respond_to do |format|
      if @notificacion.save
        format.html { redirect_to @notificacion, notice: "Notificación creada correctamente." }
        format.json { render :show, status: :created, location: @notificacion }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @notificacion.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /notificacions/1
  def update
    respond_to do |format|
      if @notificacion.update(notificacion_params)
        format.html { redirect_to @notificacion, notice: "Notificación actualizada correctamente." }
        format.json { render :show, status: :ok, location: @notificacion }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @notificacion.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /notificacions/1
  def destroy
    @notificacion.destroy
    respond_to do |format|
      format.html { redirect_to notificacions_path, notice: "Notificación eliminada." }
      format.json { head :no_content }
    end
  end

  private

    def set_notificacion
      @notificacion = Notificacion.find(params[:id])
    end

    def notificacion_params
      params.require(:notificacion).permit(:cliente_id, :mensaje, :fecha_envio, :informe_id)
    end

    def authorize_gerente
      unless current_user.gerente?
        redirect_to root_path, alert: "Acceso restringido a gerentes."
      end
    end
end
