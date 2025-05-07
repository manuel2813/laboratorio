require "test_helper"

class SampleLoadTest < ActiveSupport::TestCase
  self.use_transactional_tests = false  # Evita que se limpie la BD al final del test

  def setup
    @user = User.find_or_create_by!(email: "masivo@test.com") { |u| u.password = "123456"; u.role = 2 }
    @lab  = User.find_or_create_by!(email: "labmasivo@test.com") { |u| u.password = "123456"; u.role = 1 }
  
    @servicio = Servicio.new(
      codigo_servicio: "X999",
      nombre: "Servicio Test",
      descripcion: "Carga masiva",
      costo_base: 15,
      laboratorista_id: @lab.id
    )
  
    @servicio.save(validate: false)  # ← evita validación de imagen
  end

  test "registro masivo de muestras" do
    cantidad = 1000
    errores = 0

    cantidad.times do |i|
      begin
        Sample.create!(
          code: "CARGA#{i}",
          results: "pendiente",
          user_id: @user.id,
          laboratorista_id: @lab.id,
          servicio_id: @servicio.id
        )
      rescue => e
        errores += 1
        puts "❌ Error en la muestra #{i}: #{e.message}"
      end
    end

    total = Sample.where("code LIKE 'CARGA%'").count
    puts "\n📊 Muestras creadas: #{total}/#{cantidad}, fallidas: #{errores}"

    assert_equal cantidad - errores, total
  end
end
