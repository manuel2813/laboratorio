class CreateCostosServicioPorTipoClientes < ActiveRecord::Migration[7.0]
  def change
    create_table :costos_servicio_por_tipo_clientes do |t|
      t.integer :tipo_cliente_id
      t.string :codigo_servicio
      t.float :costo

      t.timestamps
    end
  end
end
