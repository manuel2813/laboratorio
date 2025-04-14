class NotificacionsController < ApplicationController
  before_action :set_notificacion, only: %i[ show edit update destroy ]

  # GET /notificacions or /notificacions.json
  def index
    @notificacions = Notificacion.all
  end

  # GET /notificacions/1 or /notificacions/1.json
  def show
  end

  # GET /notificacions/new
  def new
    @notificacion = Notificacion.new
  end

  # GET /notificacions/1/edit
  def edit
  end

  # POST /notificacions or /notificacions.json
  def create
    @notificacion = Notificacion.new(notificacion_params)

    respond_to do |format|
      if @notificacion.save
        format.html { redirect_to @notificacion, notice: "Notificacion was successfully created." }
        format.json { render :show, status: :created, location: @notificacion }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @notificacion.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /notificacions/1 or /notificacions/1.json
  def update
    respond_to do |format|
      if @notificacion.update(notificacion_params)
        format.html { redirect_to @notificacion, notice: "Notificacion was successfully updated." }
        format.json { render :show, status: :ok, location: @notificacion }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @notificacion.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /notificacions/1 or /notificacions/1.json
  def destroy
    @notificacion.destroy

    respond_to do |format|
      format.html { redirect_to notificacions_path, status: :see_other, notice: "Notificacion was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_notificacion
      @notificacion = Notificacion.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def notificacion_params
      params.require(:notificacion).permit(:cliente_id, :mensaje, :fecha_envio, :informe_id)
    end
end
