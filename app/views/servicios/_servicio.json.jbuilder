json.extract! servicio, :id, :codigo_servicio, :nombre, :descripcion, :costo_base, :laboratorista_id, :created_at, :updated_at
json.url servicio_url(servicio, format: :json)
