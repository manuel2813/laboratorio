class CreateCostosServicioPorTipoClientes < ActiveRecord::Migration[7.0]
  def change
    create_table :costos_servicio_por_tipo_clientes do |t|
      t.references :tipo_cliente, foreign_key: true
      t.references :servicio, foreign_key: true
      t.decimal :costo, precision: 10, scale: 2

      t.timestamps
    end
  end
end
