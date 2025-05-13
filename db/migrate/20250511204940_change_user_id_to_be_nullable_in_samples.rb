class ChangeUserIdToBeNullableInSamples < ActiveRecord::Migration[7.0]
  def change
    change_column_null :samples, :user_id, true
  end
end