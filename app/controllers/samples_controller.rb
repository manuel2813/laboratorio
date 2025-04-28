class SamplesController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_not_admin, except: [:index, :show]
  before_action :set_sample, only: [:show, :edit, :update, :destroy, :export_pdf, :guardar_resultado, :cargar_resultado_individual]
  before_action :authorize_sample_access, only: [:edit, :update, :destroy]

  def index
    @samples = if current_user.admin?
                 Sample.all
               elsif current_user.laboratorista?
                 Sample.where(laboratorista: current_user)
               elsif current_user.cliente?
                 Sample.where(user: current_user)
               else
                 Sample.none
               end
  end

  def show
    if @sample.nil?
      redirect_to samples_path, alert: "La muestra ya no existe o ha sido eliminada."
    else
      respond_to do |format|
        format.html
        format.pdf do
          pdf = Prawn::Document.new
          pdf.text "Detalle de la Muestra", size: 20, style: :bold
          pdf.move_down 20
          pdf.text "Código: #{@sample.code}"
          pdf.text "Resultados: #{@sample.results}"
          pdf.text "Cliente: #{@sample.user&.email || 'No asignado'}"
          pdf.text "Laboratorista: #{@sample.laboratorista&.email || 'No asignado'}"
          send_data pdf.render,
                    filename: "muestra_#{@sample.code}.pdf",
                    type: 'application/pdf',
                    disposition: 'inline'
        end
      end
    end
  end

  def new
    @sample = Sample.new
  end

  def create
    @sample = Sample.new(sample_params)
    @sample.laboratorista = current_user if current_user.laboratorista?
    @sample.user = current_user if current_user.cliente?

    if @sample.save
      redirect_to samples_path, notice: 'Muestra creada correctamente.'
    else
      flash.now[:alert] = 'Hubo un error al crear la muestra. Revisa los campos.'
      render :new
    end
  end

  def edit; end

  def update
    if @sample.update(sample_params)
      @sample.touch unless @sample.previous_changes.any?
      flash[:notice] = "Muestra actualizada correctamente."
      redirect_to samples_path
    else
      flash.now[:alert] = 'Hubo un error al actualizar la muestra.'
      render :edit
    end
  end

  def destroy
    @sample.destroy
    redirect_to samples_path, notice: 'Muestra eliminada correctamente.'
  end

  def export_pdf
    pdf = Prawn::Document.new(page_size: 'A4', margin: 50)
    logo_path = Rails.root.join('app', 'assets', 'images', 'logo.png')
    pdf.image(logo_path, width: 80, position: :center) if File.exist?(logo_path)
    pdf.move_down 10
    pdf.text "Laboratorio Central de Investigación - UNAS", size: 18, style: :bold, align: :center
    pdf.move_down 20
    pdf.text "FICHA DE MUESTRA", size: 22, style: :bold, align: :center, color: "006400"
    pdf.move_down 30

    data = [
      ["Código de Muestra", @sample.code],
      ["Resultados", @sample.results.to_s],
      ["Cliente", @sample.user&.email || "Sin asignar"],
      ["Laboratorista", @sample.laboratorista&.email || "Sin asignar"]
    ]

    pdf.table(data, width: pdf.bounds.width) do
      row(0..-1).columns(0).font_style = :bold
      row(0..-1).columns(0).background_color = "f0f0f0"
      row(0..-1).padding = 10
      self.cell_style = { borders: [:bottom], border_width: 0.5 }
    end

    pdf.move_down 40
    pdf.text "Emitido el: #{I18n.l(Time.zone.now, format: :long)}", size: 10, align: :right, style: :italic

    send_data pdf.render,
              filename: "muestra_#{@sample.code}.pdf",
              type: 'application/pdf',
              disposition: 'inline'
  end

  def cargar_resultado
    if current_user.laboratorista?
      @samples = Sample.where(laboratorista: current_user)
    else
      redirect_to root_path, alert: "Acceso no autorizado."
    end
  end

  def editar_resultado
    @sample = Sample.find_by(id: params[:id])
    if @sample
      render :cargar_resultado_individual
    else
      redirect_to samples_path, alert: "Muestra no encontrada."
    end
  end

  def guardar_resultado
    if @sample.update(sample_params)
      redirect_to cargar_resultado_samples_path, notice: 'Resultado guardado correctamente.'
    else
      flash.now[:alert] = 'No se pudo guardar el resultado.'
      render :cargar_resultado_individual
    end
  end
  
  
  def cargar_resultado
    if current_user.laboratorista?
      @samples = Sample.where(laboratorista: current_user)
    else
      redirect_to root_path, alert: "Acceso no autorizado."
    end
  end
  
  private

  def set_sample
    @sample = Sample.find_by(id: params[:id])
    redirect_to samples_path, alert: 'La muestra solicitada no existe.' unless @sample
  end

  def ensure_not_admin
    redirect_to users_path, alert: 'Los administradores no tienen acceso a esta acción.' if current_user.admin?
  end

  def authorize_sample_access
    unless can_access_sample?(@sample)
      redirect_to samples_path, alert: 'No tienes permiso para acceder a esta muestra.'
    end
  end

  def can_access_sample?(sample)
    if current_user.laboratorista?
      sample.laboratorista == current_user
    elsif current_user.cliente?
      sample.user == current_user
    else
      false
    end
  end

  def sample_params
    params.require(:sample).permit(:code, :results, :user_id, :servicio_id, :fecha_recepcion, :fecha_resultado, :estado, :observaciones)
  end
  
end
