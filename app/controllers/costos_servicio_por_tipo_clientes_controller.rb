class CostosServicioPorTipoClientesController < ApplicationController
  before_action :set_costos_servicio_por_tipo_cliente, only: %i[ show edit update destroy ]

  # GET /costos_servicio_por_tipo_clientes or /costos_servicio_por_tipo_clientes.json
  def index
    @costos_servicio_por_tipo_clientes = CostosServicioPorTipoCliente.all
  end

  # GET /costos_servicio_por_tipo_clientes/1 or /costos_servicio_por_tipo_clientes/1.json
  def show
  end

  # GET /costos_servicio_por_tipo_clientes/new
  def new
    @costos_servicio_por_tipo_cliente = CostosServicioPorTipoCliente.new
  end

  # GET /costos_servicio_por_tipo_clientes/1/edit
  def edit
  end

  # POST /costos_servicio_por_tipo_clientes or /costos_servicio_por_tipo_clientes.json
  def create
    @costos_servicio_por_tipo_cliente = CostosServicioPorTipoCliente.new(costos_servicio_por_tipo_cliente_params)

    respond_to do |format|
      if @costos_servicio_por_tipo_cliente.save
        format.html { redirect_to @costos_servicio_por_tipo_cliente, notice: "Costos servicio por tipo cliente was successfully created." }
        format.json { render :show, status: :created, location: @costos_servicio_por_tipo_cliente }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @costos_servicio_por_tipo_cliente.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /costos_servicio_por_tipo_clientes/1 or /costos_servicio_por_tipo_clientes/1.json
  def update
    respond_to do |format|
      if @costos_servicio_por_tipo_cliente.update(costos_servicio_por_tipo_cliente_params)
        format.html { redirect_to @costos_servicio_por_tipo_cliente, notice: "Costos servicio por tipo cliente was successfully updated." }
        format.json { render :show, status: :ok, location: @costos_servicio_por_tipo_cliente }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @costos_servicio_por_tipo_cliente.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /costos_servicio_por_tipo_clientes/1 or /costos_servicio_por_tipo_clientes/1.json
  def destroy
    @costos_servicio_por_tipo_cliente.destroy

    respond_to do |format|
      format.html { redirect_to costos_servicio_por_tipo_clientes_path, status: :see_other, notice: "Costos servicio por tipo cliente was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_costos_servicio_por_tipo_cliente
      @costos_servicio_por_tipo_cliente = CostosServicioPorTipoCliente.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def costos_servicio_por_tipo_cliente_params
      params.require(:costos_servicio_por_tipo_cliente).permit(:tipo_cliente_id, :codigo_servicio, :costo)
    end
end
