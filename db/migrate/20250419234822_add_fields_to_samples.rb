class AddFieldsToSamples < ActiveRecord::Migration[7.0]
  def change
    add_column :samples, :servicio_id, :integer
    #add_column :samples, :laboratorista_id, :integer
    add_column :samples, :fecha_recepcion, :date
    add_column :samples, :prioridad, :string
    add_column :samples, :observaciones, :text
  end
end
