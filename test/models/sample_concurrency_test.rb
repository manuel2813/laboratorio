require "test_helper"
require "thread"

class SampleConcurrencyTest < ActiveSupport::TestCase
  # Desactivar uso de fixtures
  self.use_instantiated_fixtures = false
  self.use_transactional_tests = true

  def setup
    # Crear dos usuarios mínimos para la prueba (cliente y laboratorista)
    user1 = User.create!(email: "cliente@test.com", password: "123456", role: 2)
    user2 = User.create!(email: "lab@test.com", password: "123456", role: 1)

    @sample = Sample.create!(
      code: "M123",
      results: "pendiente",
      user_id: user1.id,
      laboratorista_id: user2.id
    )
  end

  test "evita sobrescritura con lock_version" do
    errors = []

    threads = 2.times.map do |i|
      Thread.new do
        begin
          sample = Sample.find(@sample.id)
          sleep(0.2) if i == 0
          sample.results = "resultado_#{i}"
          sample.save!
        rescue => e
          errors << e.message
        end
      end
    end

    threads.each(&:join)

    @sample.reload
    puts "Estado final del sample: #{@sample.results}"
    puts "Errores: #{errors.inspect}"

    assert errors.any?, "Se esperaba que al menos una modificación fallara por conflicto de versión"
  end
end
