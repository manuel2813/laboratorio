require "application_system_test_case"

class NotificacionsTest < ApplicationSystemTestCase
  setup do
    @notificacion = notificacions(:one)
  end

  test "visiting the index" do
    visit notificacions_url
    assert_selector "h1", text: "Notificacions"
  end

  test "should create notificacion" do
    visit notificacions_url
    click_on "New notificacion"

    fill_in "Cliente", with: @notificacion.cliente_id
    fill_in "Fecha envio", with: @notificacion.fecha_envio
    fill_in "Informe", with: @notificacion.informe_id
    fill_in "Mensaje", with: @notificacion.mensaje
    click_on "Create Notificacion"

    assert_text "Notificacion was successfully created"
    click_on "Back"
  end

  test "should update Notificacion" do
    visit notificacion_url(@notificacion)
    click_on "Edit this notificacion", match: :first

    fill_in "Cliente", with: @notificacion.cliente_id
    fill_in "Fecha envio", with: @notificacion.fecha_envio
    fill_in "Informe", with: @notificacion.informe_id
    fill_in "Mensaje", with: @notificacion.mensaje
    click_on "Update Notificacion"

    assert_text "Notificacion was successfully updated"
    click_on "Back"
  end

  test "should destroy Notificacion" do
    visit notificacion_url(@notificacion)
    click_on "Destroy this notificacion", match: :first

    assert_text "Notificacion was successfully destroyed"
  end
end
