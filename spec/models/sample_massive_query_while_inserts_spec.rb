# spec/models/sample_massive_query_while_inserts_spec.rb
require 'rails_helper'

RSpec.describe Sample, type: :model do
  it "permite consultas masivas mientras se registran datos concurrentemente" do
    # Crear cliente con tipo de cliente
    cliente = User.find_or_create_by!(email: "cliente_query@test.com") do |u|
      u.password = "123456"
      u.password_confirmation = "123456"
      u.role = :cliente
      u.tipo_cliente = TipoCliente.first || TipoCliente.create!(nombre: "Masivo", descripcion: "Tipo masivo")
    end

    # Crear laboratorista
    laboratorista = User.find_or_create_by!(email: "lab_query@test.com") do |u|
      u.password = "123456"
      u.password_confirmation = "123456"
      u.role = :laboratorista
    end

    # Crear o reutilizar servicio con imagen válida
    servicio = Servicio.find_by(codigo_servicio: "SRV_MASS_QUERY")
    unless servicio&.imagen_archivo&.attached?
      servicio ||= Servicio.new(
        codigo_servicio: "SRV_MASS_QUERY",
        nombre: "Servicio Consulta Masiva",
        descripcion: "Test concurrencia con consulta",
        costo_base: 0,
        laboratorista_id: laboratorista.id
      )
      servicio.imagen_archivo.attach(
        io: File.open(Rails.root.join("spec", "fixtures", "files", "placeholder.png")),
        filename: "placeholder.png",
        content_type: "image/png"
      )
      servicio.save!
    end

    errors = []
    created_codes = []

    # Hilo para insertar 100 muestras
    inserter = Thread.new do
      100.times do |i|
        begin
          Sample.create!(
            code: "CONS#{i}",
            results: "Res #{i}",
            user: cliente,
            laboratorista: laboratorista,
            fecha_recepcion: Date.today,
            prioridad: "media",
            observaciones: "Obs #{i}",
            servicio: servicio,
            estado: "pendiente"
          )
          created_codes << "CONS#{i}"
          sleep(0.01)
        rescue => e
          errors << "Insert #{i} - #{e.class}: #{e.message}"
        end
      end
    end

    # Hilo para consultas masivas
    querier = Thread.new do
      100.times do |j|
        count = Sample.where("code LIKE ?", "CONS%").count
        puts " Consulta #{j + 1}: muestras tipo 'CONS%' registradas: #{count}"
        $stdout.flush
        sleep(0.015)
      end
    end

    # Esperar hilos
    [inserter, querier].each(&:join)

    # Resultados en consola
    puts "\n Códigos insertados: #{created_codes.size}"
    puts " Lista de códigos: #{created_codes.sort.join(', ')}"
    puts " Errores durante inserciones: #{errors.size}" if errors.any?
    errors.each { |e| puts "- #{e}" }

    # Validación final
    expect(Sample.where("code LIKE ?", "CONS%").count).to eq(100)
  end
end
