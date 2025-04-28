class AddExtraFieldsToSamples < ActiveRecord::Migration[7.0]
  def change
    # Ya existen: :fecha_recepcion, :prioridad, :observaciones
    # Solo agregar lo que falta:
    add_column :samples, :fecha_resultado, :date
    add_column :samples, :estado, :string
  end
end