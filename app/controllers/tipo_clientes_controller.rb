class TipoClientesController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_gerente
  before_action :set_tipo_cliente, only: %i[ show edit update destroy ]

  # GET /tipo_clientes
  def index
    @tipo_clientes = TipoCliente.all
  end

  # GET /tipo_clientes/1
  def show
  end

  # GET /tipo_clientes/new
  def new
    @tipo_cliente = TipoCliente.new
  end

  # GET /tipo_clientes/1/edit
  def edit
  end

  # POST /tipo_clientes
  def create
    @tipo_cliente = TipoCliente.new(tipo_cliente_params)

    if @tipo_cliente.save
      redirect_to @tipo_cliente, notice: "Tipo de cliente creado correctamente."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /tipo_clientes/1
  def update
    if @tipo_cliente.update(tipo_cliente_params)
      redirect_to @tipo_cliente, notice: "Tipo de cliente actualizado correctamente."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /tipo_clientes/1
  def destroy
    @tipo_cliente.destroy
    redirect_to tipo_clientes_url, status: :see_other, notice: "Tipo de cliente eliminado correctamente."
  end

  private

    def set_tipo_cliente
      @tipo_cliente = TipoCliente.find(params[:id])
    end

    def tipo_cliente_params
      params.require(:tipo_cliente).permit(:nombre, :descripcion)
    end

    def authorize_gerente
      unless current_user&.gerente?
        redirect_to root_path, alert: "Acceso denegado: solo disponible para gerentes."
      end
    end
end
