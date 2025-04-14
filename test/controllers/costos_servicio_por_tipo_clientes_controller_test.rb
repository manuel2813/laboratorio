require "test_helper"

class CostosServicioPorTipoClientesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @costos_servicio_por_tipo_cliente = costos_servicio_por_tipo_clientes(:one)
  end

  test "should get index" do
    get costos_servicio_por_tipo_clientes_url
    assert_response :success
  end

  test "should get new" do
    get new_costos_servicio_por_tipo_cliente_url
    assert_response :success
  end

  test "should create costos_servicio_por_tipo_cliente" do
    assert_difference("CostosServicioPorTipoCliente.count") do
      post costos_servicio_por_tipo_clientes_url, params: { costos_servicio_por_tipo_cliente: { codigo_servicio: @costos_servicio_por_tipo_cliente.codigo_servicio, costo: @costos_servicio_por_tipo_cliente.costo, tipo_cliente_id: @costos_servicio_por_tipo_cliente.tipo_cliente_id } }
    end

    assert_redirected_to costos_servicio_por_tipo_cliente_url(CostosServicioPorTipoCliente.last)
  end

  test "should show costos_servicio_por_tipo_cliente" do
    get costos_servicio_por_tipo_cliente_url(@costos_servicio_por_tipo_cliente)
    assert_response :success
  end

  test "should get edit" do
    get edit_costos_servicio_por_tipo_cliente_url(@costos_servicio_por_tipo_cliente)
    assert_response :success
  end

  test "should update costos_servicio_por_tipo_cliente" do
    patch costos_servicio_por_tipo_cliente_url(@costos_servicio_por_tipo_cliente), params: { costos_servicio_por_tipo_cliente: { codigo_servicio: @costos_servicio_por_tipo_cliente.codigo_servicio, costo: @costos_servicio_por_tipo_cliente.costo, tipo_cliente_id: @costos_servicio_por_tipo_cliente.tipo_cliente_id } }
    assert_redirected_to costos_servicio_por_tipo_cliente_url(@costos_servicio_por_tipo_cliente)
  end

  test "should destroy costos_servicio_por_tipo_cliente" do
    assert_difference("CostosServicioPorTipoCliente.count", -1) do
      delete costos_servicio_por_tipo_cliente_url(@costos_servicio_por_tipo_cliente)
    end

    assert_redirected_to costos_servicio_por_tipo_clientes_url
  end
end
