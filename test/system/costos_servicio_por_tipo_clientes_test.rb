require "application_system_test_case"

class CostosServicioPorTipoClientesTest < ApplicationSystemTestCase
  setup do
    @costos_servicio_por_tipo_cliente = costos_servicio_por_tipo_clientes(:one)
  end

  test "visiting the index" do
    visit costos_servicio_por_tipo_clientes_url
    assert_selector "h1", text: "Costos servicio por tipo clientes"
  end

  test "should create costos servicio por tipo cliente" do
    visit costos_servicio_por_tipo_clientes_url
    click_on "New costos servicio por tipo cliente"

    fill_in "Codigo servicio", with: @costos_servicio_por_tipo_cliente.codigo_servicio
    fill_in "Costo", with: @costos_servicio_por_tipo_cliente.costo
    fill_in "Tipo cliente", with: @costos_servicio_por_tipo_cliente.tipo_cliente_id
    click_on "Create Costos servicio por tipo cliente"

    assert_text "Costos servicio por tipo cliente was successfully created"
    click_on "Back"
  end

  test "should update Costos servicio por tipo cliente" do
    visit costos_servicio_por_tipo_cliente_url(@costos_servicio_por_tipo_cliente)
    click_on "Edit this costos servicio por tipo cliente", match: :first

    fill_in "Codigo servicio", with: @costos_servicio_por_tipo_cliente.codigo_servicio
    fill_in "Costo", with: @costos_servicio_por_tipo_cliente.costo
    fill_in "Tipo cliente", with: @costos_servicio_por_tipo_cliente.tipo_cliente_id
    click_on "Update Costos servicio por tipo cliente"

    assert_text "Costos servicio por tipo cliente was successfully updated"
    click_on "Back"
  end

  test "should destroy Costos servicio por tipo cliente" do
    visit costos_servicio_por_tipo_cliente_url(@costos_servicio_por_tipo_cliente)
    click_on "Destroy this costos servicio por tipo cliente", match: :first

    assert_text "Costos servicio por tipo cliente was successfully destroyed"
  end
end
