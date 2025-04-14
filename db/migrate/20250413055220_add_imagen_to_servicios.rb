class AddImagenToServicios < ActiveRecord::Migration[7.0]
  def change
    add_column :servicios, :imagen, :string
  end
end
