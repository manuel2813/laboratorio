require "test_helper"

class LaboratoristaControllerTest < ActionDispatch::IntegrationTest
  test "should get dashboard" do
    get laboratorista_dashboard_url
    assert_response :success
  end
end
