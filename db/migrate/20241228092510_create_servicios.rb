class CreateServicios < ActiveRecord::Migration[7.0]
  def change
    create_table :servicios do |t|
      t.string :codigo_servicio
      t.string :nombre
      t.text :descripcion
      t.float :costo_base
      t.integer :laboratorista_id

      t.timestamps
    end
  end
end
