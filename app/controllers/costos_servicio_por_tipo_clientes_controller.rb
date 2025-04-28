class CostosServicioPorTipoClientesController < ApplicationController
  require "prawn/table"
  before_action :set_costos_servicio_por_tipo_cliente, only: %i[ show edit update destroy export_pdf ]
  before_action :authenticate_user!
  before_action :authorize_gerente

  # GET /costos_servicio_por_tipo_clientes
  def index
    @from_date = params[:from_date]
    @to_date = params[:to_date]

    @costos_servicio_por_tipo_clientes = CostosServicioPorTipoCliente.includes(:servicio, :tipo_cliente)

    if @from_date.present? && @to_date.present?
      @costos_servicio_por_tipo_clientes = @costos_servicio_por_tipo_clientes.where(created_at: @from_date.to_date.beginning_of_day..@to_date.to_date.end_of_day)
    end
  end

  # GET /costos_servicio_por_tipo_clientes/1
  def show
  end

  # GET /costos_servicio_por_tipo_clientes/new
  def new
    @costos_servicio_por_tipo_cliente = CostosServicioPorTipoCliente.new
  end

  # GET /costos_servicio_por_tipo_clientes/1/edit
  def edit
  end

  # POST /costos_servicio_por_tipo_clientes
  def create
    @costos_servicio_por_tipo_cliente = CostosServicioPorTipoCliente.new(costos_servicio_por_tipo_cliente_params)

    respond_to do |format|
      if @costos_servicio_por_tipo_cliente.save
        format.html { redirect_to costos_servicio_por_tipo_clientes_path, notice: "Costo creado correctamente." }
        format.json { render :show, status: :created, location: @costos_servicio_por_tipo_cliente }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @costos_servicio_por_tipo_cliente.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /costos_servicio_por_tipo_clientes/1
  def update
    respond_to do |format|
      if @costos_servicio_por_tipo_cliente.update(costos_servicio_por_tipo_cliente_params)
        format.html { redirect_to costos_servicio_por_tipo_clientes_path, notice: "Costo actualizado correctamente." }
        format.json { render :show, status: :ok, location: @costos_servicio_por_tipo_cliente }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @costos_servicio_por_tipo_cliente.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /costos_servicio_por_tipo_clientes/1
  def destroy
    @costos_servicio_por_tipo_cliente.destroy

    respond_to do |format|
      format.html { redirect_to costos_servicio_por_tipo_clientes_path, notice: "Costo eliminado correctamente." }
      format.json { head :no_content }
    end
  end

  # GET /costos_servicio_por_tipo_clientes/:id/export_pdf
  def export_pdf
    servicio = Servicio.find_by(codigo_servicio: @costos_servicio_por_tipo_cliente.codigo_servicio)

    pdf = Prawn::Document.new
    pdf.text "Ficha de Costo por Tipo de Cliente", size: 18, style: :bold, align: :center
    pdf.move_down 20

    pdf.text "Tipo de Cliente: #{@costos_servicio_por_tipo_cliente.tipo_cliente&.nombre}", size: 12
    pdf.text "Código del Servicio: #{@costos_servicio_por_tipo_cliente.codigo_servicio}", size: 12
    pdf.text "Nombre del Servicio: #{servicio&.nombre || 'No disponible'}", size: 12
    pdf.text "Costo (S/): S/ #{'%.2f' % @costos_servicio_por_tipo_cliente.costo}", size: 12
    pdf.text "Fecha de Registro: #{@costos_servicio_por_tipo_cliente.created_at.strftime('%d/%m/%Y')}", size: 12

    send_data pdf.render,
              filename: "costo_tipo_cliente_#{@costos_servicio_por_tipo_cliente.id}.pdf",
              type: "application/pdf",
              disposition: "inline"
  end

  # GET /costos_servicio_por_tipo_clientes/export_all_pdf
  def export_all_pdf
    from_date = params[:from_date]
    to_date = params[:to_date]

    @costos = CostosServicioPorTipoCliente.includes(:tipo_cliente, :servicio)

    if from_date.present? && to_date.present?
      @costos = @costos.where(created_at: from_date.to_date.beginning_of_day..to_date.to_date.end_of_day)
    end

    pdf = Prawn::Document.new
    pdf.text "Listado de Costos por Tipo de Cliente", size: 18, style: :bold, align: :center
    pdf.move_down 20

    table_data = [["Tipo de Cliente", "Código Servicio", "Nombre Servicio", "Costo (S/.)"]]

    @costos.each do |costo|
      servicio = Servicio.find_by(codigo_servicio: costo.codigo_servicio)
      table_data << [
        costo.tipo_cliente&.nombre || "N/A",
        costo.codigo_servicio,
        servicio&.nombre || "No disponible",
        "S/ #{'%.2f' % costo.costo}"
      ]
    end

    pdf.table(table_data, header: true, row_colors: %w[F0F0F0 FFFFFF], width: pdf.bounds.width)

    send_data pdf.render,
              filename: "listado_costos_por_tipo_cliente.pdf",
              type: "application/pdf",
              disposition: "inline"
  end

  private
    def set_costos_servicio_por_tipo_cliente
      @costos_servicio_por_tipo_cliente = CostosServicioPorTipoCliente.find(params[:id])
    end

    def costos_servicio_por_tipo_cliente_params
      params.require(:costos_servicio_por_tipo_cliente).permit(:tipo_cliente_id, :codigo_servicio, :costo)
    end

    def authorize_gerente
      redirect_to root_path, alert: "Acceso restringido al gerente." unless current_user&.gerente?
    end
end