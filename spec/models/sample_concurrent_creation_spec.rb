require 'rails_helper'

RSpec.describe Sample, type: :model do
  it "registra múltiples muestras distintas sin errores de concurrencia" do
    cliente = User.find_or_create_by!(email: "cliente_concurrente@test.com") do |u|
      u.password = "123456"
      u.password_confirmation = "123456"
      u.role = :cliente
      u.tipo_cliente = TipoCliente.first || TipoCliente.create!(nombre: "Básico", descripcion: "Para test")
    end

    laboratorista = User.find_or_create_by!(email: "lab_concurrente@test.com") do |u|
      u.password = "123456"
      u.password_confirmation = "123456"
      u.role = :laboratorista
    end

    servicio = Servicio.find_by(codigo_servicio: "SRV_CONC_001")
    unless servicio&.imagen_archivo&.attached?
      servicio ||= Servicio.new(
        codigo_servicio: "SRV_CONC_001",
        nombre: "Servicio Concurrente",
        descripcion: "Para test de concurrencia",
        costo_base: 0,
        laboratorista_id: laboratorista.id
      )

      file_path = Rails.root.join("spec", "fixtures", "files", "placeholder.png")
      servicio.imagen_archivo.attach(io: File.open(file_path), filename: "placeholder.png", content_type: "image/png")
      servicio.save!
    end

    errors = []
    threads = []

    10000.times do |i|
      threads << Thread.new do
        ActiveRecord::Base.connection_pool.with_connection do
          begin
            Sample.create!(
              code: "UNIQ#{i}",
              results: "Resultado #{i}",
              user: cliente,
              laboratorista: laboratorista,
              fecha_recepcion: Date.today,
              prioridad: "alta",
              observaciones: "Observación #{i}",
              servicio: servicio,
              estado: "pendiente"
            )
          rescue => e
            errors << "Thread #{i} - #{e.class}: #{e.message}"
          end
        end
      end
    end
    

    threads.each(&:join)

    puts "\n Muestras registradas: #{Sample.where("code LIKE ?", "UNIQ%").pluck(:code).inspect}"
    puts " Errores encontrados: #{errors.count}" if errors.any?
    errors.each { |e| puts "- #{e}" }

    expect(Sample.where("code LIKE ?", "UNIQ%").count).to eq(10000)
  end
end
