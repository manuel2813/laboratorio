# spec/models/sample_concurrent_process_create_spec.rb
require 'rails_helper'

RSpec.describe Sample, type: :model do
  it "procesa y registra muestras simultáneamente sin errores de concurrencia (100 cada uno)" do
    # Cliente con tipo
    cliente = User.find_or_create_by!(email: "cliente_proc@test.com") do |u|
      u.password = "123456"
      u.password_confirmation = "123456"
      u.role = :cliente
      u.tipo_cliente = TipoCliente.first || TipoCliente.create!(nombre: "Procesamiento", descripcion: "Para test")
    end

    # Laboratorista
    laboratorista = User.find_or_create_by!(email: "lab_proc@test.com") do |u|
      u.password = "123456"
      u.password_confirmation = "123456"
      u.role = :laboratorista
    end

    # Servicio válido con imagen
    servicio = Servicio.find_by(codigo_servicio: "PROC_001")
    unless servicio&.imagen_archivo&.attached?
      servicio ||= Servicio.new(
        codigo_servicio: "PROC_001",
        nombre: "Servicio Procesamiento",
        descripcion: "Servicio usado para test de procesamiento concurrente",
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

    # Crear 100 muestras iniciales
    processed_ids = 100.times.map do |i|
      Sample.create!(
        code: "PROC#{i}",
        results: "Pendiente",
        user: cliente,
        laboratorista: laboratorista,
        fecha_recepcion: Date.today,
        prioridad: "media",
        observaciones: "Procesamiento #{i}",
        servicio: servicio,
        estado: "pendiente"
      ).id
    end

    errors = []
    threads = []

    # Threads para actualizar los resultados de las muestras ya existentes
    processed_ids.each do |id|
      threads << Thread.new do
        ActiveRecord::Base.connection_pool.with_connection do
          begin
            sample = Sample.find(id)
            sample.update!(results: "Resultado actualizado", estado: "procesado")
          rescue => e
            errors << "Procesamiento - Sample #{id}: #{e.class} - #{e.message}"
          end
        end
      end
    end

    # Threads para registrar nuevas muestras
    100.times do |i|
      threads << Thread.new do
        ActiveRecord::Base.connection_pool.with_connection do
          begin
            Sample.create!(
              code: "NUEVO#{i}",
              results: "Resultado nuevo #{i}",
              user: cliente,
              laboratorista: laboratorista,
              fecha_recepcion: Date.today,
              prioridad: "alta",
              observaciones: "Nuevo registro #{i}",
              servicio: servicio,
              estado: "pendiente"
            )
          rescue => e
            errors << "Registro - NUEVO#{i}: #{e.class} - #{e.message}"
          end
        end
      end
    end

    # Esperar a que todos los hilos terminen
    threads.each(&:join)

    puts "\n Total actualizaciones esperadas: 100"
    puts " Total nuevos registros esperados: 100"
    puts " Errores encontrados: #{errors.count}" if errors.any?
    errors.each { |e| puts "- #{e}" }

    expect(Sample.where("code LIKE ?", "PROC%").where(results: "Resultado actualizado").count).to eq(100)
    expect(Sample.where("code LIKE ?", "NUEVO%").count).to eq(100)
  end
end
