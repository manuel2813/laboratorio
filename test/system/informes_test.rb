require "application_system_test_case"

class InformesTest < ApplicationSystemTestCase
  setup do
    @informe = informes(:one)
  end

  test "visiting the index" do
    visit informes_url
    assert_selector "h1", text: "Informes"
  end

  test "should create informe" do
    visit informes_url
    click_on "New informe"

    fill_in "Archivo", with: @informe.archivo
    fill_in "Codigo solicitud", with: @informe.codigo_solicitud
    fill_in "Estado", with: @informe.estado
    fill_in "Fecha envio cliente", with: @informe.fecha_envio_cliente
    fill_in "Fecha firma gerente", with: @informe.fecha_firma_gerente
    fill_in "Fecha generacion", with: @informe.fecha_generacion
    fill_in "Gerente", with: @informe.gerente_id
    fill_in "Laboratorista", with: @informe.laboratorista_id
    click_on "Create Informe"

    assert_text "Informe was successfully created"
    click_on "Back"
  end

  test "should update Informe" do
    visit informe_url(@informe)
    click_on "Edit this informe", match: :first

    fill_in "Archivo", with: @informe.archivo
    fill_in "Codigo solicitud", with: @informe.codigo_solicitud
    fill_in "Estado", with: @informe.estado
    fill_in "Fecha envio cliente", with: @informe.fecha_envio_cliente
    fill_in "Fecha firma gerente", with: @informe.fecha_firma_gerente
    fill_in "Fecha generacion", with: @informe.fecha_generacion
    fill_in "Gerente", with: @informe.gerente_id
    fill_in "Laboratorista", with: @informe.laboratorista_id
    click_on "Update Informe"

    assert_text "Informe was successfully updated"
    click_on "Back"
  end

  test "should destroy Informe" do
    visit informe_url(@informe)
    click_on "Destroy this informe", match: :first

    assert_text "Informe was successfully destroyed"
  end
end
