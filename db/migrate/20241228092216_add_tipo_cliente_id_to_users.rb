class AddTipoClienteIdToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :tipo_cliente_id, :integer
  end
end
