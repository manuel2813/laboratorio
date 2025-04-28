class AddServicioIdToSamples < ActiveRecord::Migration[7.0]
  def change
    add_reference :samples, :servicio, null: false, foreign_key: true
  end
end
