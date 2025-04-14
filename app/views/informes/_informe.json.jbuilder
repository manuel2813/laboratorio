json.extract! informe, :id, :codigo_solicitud, :laboratorista_id, :gerente_id, :fecha_generacion, :fecha_firma_gerente, :fecha_envio_cliente, :archivo, :estado, :created_at, :updated_at
json.url informe_url(informe, format: :json)
