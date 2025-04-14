require "test_helper"

class GerenteControllerTest < ActionDispatch::IntegrationTest
  test "should get dashboard" do
    get gerente_dashboard_url
    assert_response :success
  end
end
