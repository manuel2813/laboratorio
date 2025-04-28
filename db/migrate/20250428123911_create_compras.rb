class CreateCompras < ActiveRecord::Migration[6.0]
  def change
    create_table :compras do |t|
      t.decimal :monto, precision: 10, scale: 2
      t.references :servicio, null: false, foreign_key: true
      t.references :cliente, null: false, foreign_key: { to_table: :users }  # Cambiar aquí

      t.timestamps
    end
  end
end
