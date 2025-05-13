class ChangeSolicitudIdToBeNullableInSamples < ActiveRecord::Migration[7.0]
  def change
    change_column_null :samples, :solicitud_id, true
  end
end
