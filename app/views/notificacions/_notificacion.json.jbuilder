json.extract! notificacion, :id, :cliente_id, :mensaje, :fecha_envio, :informe_id, :created_at, :updated_at
json.url notificacion_url(notificacion, format: :json)
