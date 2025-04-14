class CreateNotificacions < ActiveRecord::Migration[7.0]
  def change
    create_table :notificacions do |t|
      t.integer :cliente_id
      t.text :mensaje
      t.datetime :fecha_envio
      t.integer :informe_id

      t.timestamps
    end
  end
end
