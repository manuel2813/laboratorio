require "test_helper"

class InformesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @informe = informes(:one)
  end

  test "should get index" do
    get informes_url
    assert_response :success
  end

  test "should get new" do
    get new_informe_url
    assert_response :success
  end

  test "should create informe" do
    assert_difference("Informe.count") do
      post informes_url, params: { informe: { archivo: @informe.archivo, codigo_solicitud: @informe.codigo_solicitud, estado: @informe.estado, fecha_envio_cliente: @informe.fecha_envio_cliente, fecha_firma_gerente: @informe.fecha_firma_gerente, fecha_generacion: @informe.fecha_generacion, gerente_id: @informe.gerente_id, laboratorista_id: @informe.laboratorista_id } }
    end

    assert_redirected_to informe_url(Informe.last)
  end

  test "should show informe" do
    get informe_url(@informe)
    assert_response :success
  end

  test "should get edit" do
    get edit_informe_url(@informe)
    assert_response :success
  end

  test "should update informe" do
    patch informe_url(@informe), params: { informe: { archivo: @informe.archivo, codigo_solicitud: @informe.codigo_solicitud, estado: @informe.estado, fecha_envio_cliente: @informe.fecha_envio_cliente, fecha_firma_gerente: @informe.fecha_firma_gerente, fecha_generacion: @informe.fecha_generacion, gerente_id: @informe.gerente_id, laboratorista_id: @informe.laboratorista_id } }
    assert_redirected_to informe_url(@informe)
  end

  test "should destroy informe" do
    assert_difference("Informe.count", -1) do
      delete informe_url(@informe)
    end

    assert_redirected_to informes_url
  end
end
