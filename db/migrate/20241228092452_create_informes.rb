class CreateInformes < ActiveRecord::Migration[7.0]
  def change
    create_table :informes do |t|
      t.string :codigo_solicitud
      t.integer :laboratorista_id
      t.integer :gerente_id
      t.datetime :fecha_generacion
      t.datetime :fecha_firma_gerente
      t.datetime :fecha_envio_cliente
      t.string :archivo
      t.string :estado

      t.timestamps
    end
  end
end
