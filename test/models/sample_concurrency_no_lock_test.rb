require "test_helper"
require "thread"

# ⚠️ Creamos clase temporal que ignora el lock_version
class SampleNoLock < Sample
  self.locking_column = nil
end

class SampleConcurrencyNoLockTest < ActiveSupport::TestCase
  self.use_instantiated_fixtures = false
  self.use_transactional_tests = true

  def setup
    user1 = User.create!(email: "user_a@test.com", password: "123456", role: 2)
    user2 = User.create!(email: "user_b@test.com", password: "123456", role: 1)

    @sample = SampleNoLock.create!(
      code: "M999",
      results: "pendiente",
      user_id: user1.id,
      laboratorista_id: user2.id
    )
  end

  test "se pierde dato sin lock_version" do
    threads = []

    2.times do |i|
      threads << Thread.new do
        sample = SampleNoLock.find(@sample.id)
        sleep(0.2) if i == 0
        sample.results = "resultado_#{i}"
        sample.save!(validate: false)
      end
    end

    threads.each(&:join)

    @sample.reload
    puts "\n\n🧪 Test SIN lock_version"
    puts "➡️ Resultado final guardado: #{@sample.results}"
    puts "⚠️ Dato anterior se perdió silenciosamente\n\n"

    assert_includes ["resultado_0", "resultado_1"], @sample.results
  end
end
