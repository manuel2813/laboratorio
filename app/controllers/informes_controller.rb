class InformesController < ApplicationController
  require 'prawn'
  require 'prawn/table'

  before_action :set_informe, only: %i[ show edit update destroy ]

  # GET /informes or /informes.json
  def index
    @informes = Informe.all

    if params[:start_date].present? && params[:end_date].present?
      start_date = Date.parse(params[:start_date]) rescue nil
      end_date = Date.parse(params[:end_date]) rescue nil

      if start_date && end_date
        @informes = @informes.where(fecha_generacion: start_date.beginning_of_day..end_date.end_of_day)
      end
    end

    respond_to do |format|
      format.html
      format.pdf do
        pdf = Prawn::Document.new
        pdf.text "📄 Reporte de Informes Generados", size: 18, style: :bold, align: :center
        pdf.move_down 20

        headers = ["Código", "Laboratorista", "Gerente", "Fecha Gen.", "Fecha Firma", "Fecha Envío", "Estado"]
        rows = @informes.map do |informe|
          [
            informe.codigo_solicitud,
            User.find_by(id: informe.laboratorista_id)&.email || "-",
            User.find_by(id: informe.gerente_id)&.email || "-",
            informe.fecha_generacion&.strftime("%d/%m/%Y") || "-",
            informe.fecha_firma_gerente&.strftime("%d/%m/%Y") || "-",
            informe.fecha_envio_cliente&.strftime("%d/%m/%Y") || "-",
            informe.estado || "-"
          ]
        end

        pdf.table([headers] + rows, header: true, row_colors: ["F0F0F0", "FFFFFF"], width: pdf.bounds.width)

        send_data pdf.render,
                  filename: "reporte_informes.pdf",
                  type: "application/pdf",
                  disposition: "inline"
      end
    end
  end

  # GET /informes/1 or /informes/1.json
  def show
  end

  # GET /informes/new
  def new
    @informe = Informe.new
  end

  # GET /informes/1/edit
  def edit
  end

  # POST /informes or /informes.json
  def create
    @informe = Informe.new(informe_params)

    respond_to do |format|
      if @informe.save
        format.html { redirect_to informes_path, notice: "Informe creado correctamente." }
        format.json { render :show, status: :created, location: @informe }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @informe.errors, status: :unprocessable_entity }
      end
    end
  end
  def generar
    @informe = Informe.new
    @samples = Sample.where(laboratorista: current_user)
  end
  
  # PATCH/PUT /informes/1 or /informes/1.json
  def update
    respond_to do |format|
      if @informe.update(informe_params)
        format.html { redirect_to informes_path, notice: "Informe creado correctamente." }
        format.json { render :show, status: :ok, location: @informe }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @informe.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /informes/1 or /informes/1.json
  def destroy
    @informe.destroy

    respond_to do |format|
      format.html { redirect_to informes_path, status: :see_other, notice: "Informe was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def export_all_pdf
    @informes = Informe.all.order(:fecha_generacion)
  
    pdf = Prawn::Document.new
    pdf.font "Helvetica"
    pdf.text " Listado Detallado de Informes", size: 18, style: :bold, align: :center
    pdf.move_down 20
  
    table_data = [
      ["Código de Solicitud", "Laboratorista ID", "Gerente ID", "Fecha de Generación", "Fecha Firma Gerente", "Fecha Envío Cliente", "Archivo", "Estado"]
    ]
  
    @informes.each do |informe|
      table_data << [
        informe.codigo_solicitud,
        informe.laboratorista_id,
        informe.gerente_id,
        informe.fecha_generacion&.strftime("%d/%m/%Y %H:%M UTC"),
        informe.fecha_firma_gerente&.strftime("%d/%m/%Y %H:%M UTC"),
        informe.fecha_envio_cliente&.strftime("%d/%m/%Y %H:%M UTC"),
        informe.archivo,
        informe.estado
      ]
    end
  
    pdf.table(table_data, header: true, row_colors: ["F0F0F0", "FFFFFF"], width: pdf.bounds.width)
  
    send_data pdf.render,
              filename: "informes_listado.pdf",
              type: "application/pdf",
              disposition: "inline"
  end


  def export_pdf
    informe = Informe.find(params[:id])
  
    pdf = Prawn::Document.new
  
    # Título
    pdf.text "Listado Detallado del Informe", size: 18, style: :bold, align: :center
    pdf.move_down 20
  
    # Datos en formato de tabla
    data = [
      ["Código de Solicitud", informe.codigo_solicitud],
      ["Laboratorista ID", informe.laboratorista_id],
      ["Gerente ID", informe.gerente_id],
      ["Fecha de Generación", informe.fecha_generacion&.strftime('%d/%m/%Y %H:%M UTC')],
      ["Fecha Firma Gerente", informe.fecha_firma_gerente&.strftime('%d/%m/%Y %H:%M UTC')],
      ["Fecha Envío Cliente", informe.fecha_envio_cliente&.strftime('%d/%m/%Y %H:%M UTC')],
      ["Archivo", informe.archivo],
      ["Estado", informe.estado]
    ]
  
    pdf.table(data, header: false, width: pdf.bounds.width) do
      row(0..-1).columns(0).font_style = :bold
      self.row_colors = ["F0F0F0", "FFFFFF"]
      self.cell_style = { borders: [:top, :bottom, :left, :right], padding: 8 }
    end
  
    # Enviar el archivo PDF como respuesta
    send_data pdf.render,
              filename: "informe_#{informe.codigo_solicitud}.pdf",
              type: "application/pdf",
              disposition: "inline"
  end
  
  private
    def set_informe
      @informe = Informe.find(params[:id])
    end

    def informe_params
      params.require(:informe).permit(:codigo_solicitud, :laboratorista_id, :gerente_id, :fecha_generacion, :fecha_firma_gerente, :fecha_envio_cliente, :archivo, :estado)
    end

    
    
end
