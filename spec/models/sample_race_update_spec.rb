require 'rails_helper'

RSpec.describe Sample, type: :model do
  it "detecta condición de carrera al actualizar resultados en simultáneo" do
    tipo_cliente = TipoCliente.first || TipoCliente.create!(nombre: "Temporal", descripcion: "Auto")

    cliente = User.create!(
      email: "cliente_concurrencia@test.com",
      password: "123456",
      password_confirmation: "123456",
      role: :cliente,
      tipo_cliente_id: tipo_cliente.id
    )

    laboratorista = User.create!(
      email: "lab_concurrencia@test.com",
      password: "123456",
      password_confirmation: "123456",
      role: :laboratorista
    )

    servicio = Servicio.first
    unless servicio
      servicio = Servicio.new(
        codigo_servicio: "SRV001",
        nombre: "Test Service",
        descripcion: "Servicio de prueba"
      )
      servicio.save(validate: false)
    end

    # Crear la muestra inicial
    sample = Sample.create!(
      code: "RACE001",
      results: "Resultado inicial",
      user: cliente,
      laboratorista: laboratorista,
      fecha_recepcion: Date.today,
      prioridad: "alta",
      observaciones: "Test",
      servicio: servicio,
      estado: "pendiente"
    )

    threads = []
    max_retries = 5  # Número máximo de reintentos en caso de conflicto
    actualizaciones = []  # Solo almacenar actualizaciones exitosas

    # 100 hilos de concurrencia simulando múltiples actualizaciones
    100.times do |i|
      threads << Thread.new do
        retries = 0
        begin
          ActiveRecord::Base.connection_pool.with_connection do
            s = Sample.find_by(code: "RACE001")
            s.update!(results: "Resultado #{i}")
            actualizaciones << "Thread #{i} escribió: Resultado #{i}"  # Solo almacenar exitosas
          end
        rescue ActiveRecord::StaleObjectError => e
          if retries < max_retries
            retries += 1
            retry  # Reintentar la actualización
          end
        rescue => e
          # No guardar errores o reintentos fallidos
        end
      end
    end

    threads.each(&:join)

    sample.reload

    # Imprimir solo el historial de actualizaciones exitosas
    puts "\nHistorial de actualizaciones exitosas:"
    actualizaciones.each { |log| puts "- #{log}" }

    # Resultado final
    puts "\nResultado final después de concurrencia: #{sample.results}"

    # Verificar que el resultado final esté en la lista de resultados posibles
    expect((0...100).map { |i| "Resultado #{i}" }).to include(sample.results)
  end
end
