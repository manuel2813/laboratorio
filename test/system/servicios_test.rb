require "application_system_test_case"

class ServiciosTest < ApplicationSystemTestCase
  setup do
    @servicio = servicios(:one)
  end

  test "visiting the index" do
    visit servicios_url
    assert_selector "h1", text: "Servicios"
  end

  test "should create servicio" do
    visit servicios_url
    click_on "New servicio"

    fill_in "Codigo servicio", with: @servicio.codigo_servicio
    fill_in "Costo base", with: @servicio.costo_base
    fill_in "Descripcion", with: @servicio.descripcion
    fill_in "Laboratorista", with: @servicio.laboratorista_id
    fill_in "Nombre", with: @servicio.nombre
    click_on "Create Servicio"

    assert_text "Servicio was successfully created"
    click_on "Back"
  end

  test "should update Servicio" do
    visit servicio_url(@servicio)
    click_on "Edit this servicio", match: :first

    fill_in "Codigo servicio", with: @servicio.codigo_servicio
    fill_in "Costo base", with: @servicio.costo_base
    fill_in "Descripcion", with: @servicio.descripcion
    fill_in "Laboratorista", with: @servicio.laboratorista_id
    fill_in "Nombre", with: @servicio.nombre
    click_on "Update Servicio"

    assert_text "Servicio was successfully updated"
    click_on "Back"
  end

  test "should destroy Servicio" do
    visit servicio_url(@servicio)
    click_on "Destroy this servicio", match: :first

    assert_text "Servicio was successfully destroyed"
  end
end
