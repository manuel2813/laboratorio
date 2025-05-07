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
    errores = []
    actualizaciones = []

    100.times do |i|
      threads << Thread.new do
        begin
          ActiveRecord::Base.connection_pool.with_connection do
            s = Sample.find_by(code: "RACE001")
            s.update!(results: "Resultado #{i}")
            actualizaciones << "Thread #{i} escribió: Resultado #{i}"
          end
        rescue => e
          errores << "Thread #{i} - #{e.class}: #{e.message}"
        end
      end
    end

    threads.each(&:join)

    sample.reload

    puts "\n Historial de actualizaciones exitosas:"
    actualizaciones.each { |log| puts "- #{log}" }

    puts "\n Resultado final después de concurrencia: #{sample.results}"
    puts " Errores encontrados:" unless errores.empty?
    errores.each { |e| puts "- #{e}" }

    expect((0...100).map { |i| "Resultado #{i}" }).to include(sample.results)
  end
end
