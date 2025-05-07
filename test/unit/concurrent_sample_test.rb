require "test_helper"
require "thread"

class ConcurrentSampleTest < ActiveSupport::TestCase
  test "registro concurrente de muestras" do
    # Crear usuarios de prueba
    user = User.find_or_create_by!(email: "concurrente_user@test.com") { |u| u.password = "123456"; u.role = 2 }
    lab  = User.find_or_create_by!(email: "concurrente_lab@test.com") { |u| u.password = "123456"; u.role = 1 }

    # Crear servicio sin validar imagen
    servicio = Servicio.find_or_initialize_by(codigo_servicio: "SRV-CONC")
    servicio.nombre = "Servicio Concurrente"
    servicio.descripcion = "Test"
    servicio.costo_base = 10
    servicio.laboratorista_id = lab.id
    servicio.save(validate: false)

    # Variables para concurrencia
    mutex = Mutex.new
    hilos = []
    errores = []

    5.times do |h|
      hilos << Thread.new do
        50.times do |i|
          begin
            mutex.synchronize do
              Sample.create!(
                code: "HILO#{h}-#{i}",
                results: "pendiente",
                user_id: user.id,
                laboratorista_id: lab.id,
                servicio_id: servicio.id
              )
            end
          rescue ActiveRecord::RecordInvalid => e
            msg = "❌ Error en HILO#{h}-#{i}: #{e.record.errors.full_messages.join(', ')}"
            puts msg
            errores << msg
          rescue => e
            msg = "❌ Error inesperado en HILO#{h}-#{i}: #{e.message}"
            puts msg
            errores << msg
          end
        end
      end
    end

    # Esperar que todos los hilos terminen
    hilos.each(&:join)

    total = Sample.where("code LIKE 'HILO%'").count
    puts "\n📊 Total creadas: #{total}, Errores: #{errores.count}"

    # Verificar que se hayan creado todas las muestras
    assert_equal 250, total, "No se crearon todas las muestras esperadas. Errores: #{errores.join(' | ')}"
  end
end
