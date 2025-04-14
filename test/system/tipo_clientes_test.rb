require "application_system_test_case"

class TipoClientesTest < ApplicationSystemTestCase
  setup do
    @tipo_cliente = tipo_clientes(:one)
  end

  test "visiting the index" do
    visit tipo_clientes_url
    assert_selector "h1", text: "Tipo clientes"
  end

  test "should create tipo cliente" do
    visit tipo_clientes_url
    click_on "New tipo cliente"

    fill_in "Descripcion", with: @tipo_cliente.descripcion
    fill_in "Nombre", with: @tipo_cliente.nombre
    click_on "Create Tipo cliente"

    assert_text "Tipo cliente was successfully created"
    click_on "Back"
  end

  test "should update Tipo cliente" do
    visit tipo_cliente_url(@tipo_cliente)
    click_on "Edit this tipo cliente", match: :first

    fill_in "Descripcion", with: @tipo_cliente.descripcion
    fill_in "Nombre", with: @tipo_cliente.nombre
    click_on "Update Tipo cliente"

    assert_text "Tipo cliente was successfully updated"
    click_on "Back"
  end

  test "should destroy Tipo cliente" do
    visit tipo_cliente_url(@tipo_cliente)
    click_on "Destroy this tipo cliente", match: :first

    assert_text "Tipo cliente was successfully destroyed"
  end
end
