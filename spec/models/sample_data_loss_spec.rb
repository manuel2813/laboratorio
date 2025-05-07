# spec/models/sample_data_loss_spec.rb
require 'rails_helper'

RSpec.describe Sample, type: :model do
  it "permite que solo una muestra con código duplicado se cree bajo concurrencia y rechaza las demás" do
    # Crear cliente con tipo de cliente
    tipo_cliente = TipoCliente.find_or_create_by!(nombre: "Test") do |tc|
      tc.descripcion = "Temporal"
    end

    cliente = User.find_or_create_by!(email: "cliente@test.com") do |u|
      u.password = "123456"
      u.password_confirmation = "123456"
      u.role = :cliente
      u.tipo_cliente = tipo_cliente
    end

    # Crear laboratorista
    laboratorista = User.find_or_create_by!(email: "lab@test.com") do |u|
      u.password = "123456"
      u.password_confirmation = "123456"
      u.role = :laboratorista
    end

    code = "DUPLICADO123"
    threads = []
    successes = []
    errors = []

    # Lanzar 100 hilos que intentan crear simultáneamente una muestra con el mismo código
    100.times do |i|
      threads << Thread.new do
        ActiveRecord::Base.connection_pool.with_connection do
          begin
            Sample.create!(
              code: code,
              results: "Resultado concurrente #{i}",
              user: cliente,
              laboratorista: laboratorista,
              fecha_recepcion: Date.today,
              prioridad: "media",
              observaciones: "Obs #{i}",
              estado: "pendiente"
            )
            successes << i
          rescue ActiveRecord::RecordInvalid => e
            mensaje = e.message.split(':').last.strip
            errors << "Thread #{i} - #{e.class}: #{mensaje}"
          end
        end
      end
    end

    # Esperar que todos los hilos terminen
    threads.each(&:join)

    puts "\n Muestras creadas exitosamente por: #{successes}"
    puts " Errores por duplicación: #{errors.size}"
    errors.each { |err| puts "- #{err}" }

    # Verificar que solo una muestra se haya creado con el código duplicado
    expect(Sample.where(code: code).count).to eq(1)
  end
end
