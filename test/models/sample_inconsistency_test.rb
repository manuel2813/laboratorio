require "test_helper"
require "thread"

class SampleInconsistencyTest < ActiveSupport::TestCase
  self.use_instantiated_fixtures = false
  self.use_transactional_tests = true

  def setup
    user1 = User.create!(email: "incons1@test.com", password: "123456", role: 2)
    user2 = User.create!(email: "incons2@test.com", password: "123456", role: 1)

    @sample = Sample.create!(
      code: "INC001",
      results: "inicio",
      user_id: user1.id,
      laboratorista_id: user2.id
    )
  end

  test "la muestra se ve distinta en distintos accesos simultáneos" do
    errores = []

    threads = 2.times.map do |i|
      Thread.new do
        begin
          sample = Sample.find(@sample.id)
          sleep(0.2) if i == 0
          sample.results = "modificado_#{i}"
          sample.save!
        rescue => e
          errores << e.message
        end
      end
    end

    threads.each(&:join)

    @sample.reload
    puts "\n\n🧪 Test de inconsistencia entre módulos"
    puts "➡️ Resultado final visible: #{@sample.results}"
    puts "❌ Errores ocurridos: #{errores.inspect}\n\n"

    # Validamos que al menos un hilo haya fallado por problema de concurrencia
    assert errores.any? { |msg| msg.include?("stale object") }, "Se esperaba inconsistencia por acceso simultáneo"
  end
end
