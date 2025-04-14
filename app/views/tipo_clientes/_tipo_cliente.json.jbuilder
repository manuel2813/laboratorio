json.extract! tipo_cliente, :id, :nombre, :descripcion, :created_at, :updated_at
json.url tipo_cliente_url(tipo_cliente, format: :json)
