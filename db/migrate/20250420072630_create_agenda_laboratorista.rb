class CreateAgendaLaboratorista < ActiveRecord::Migration[7.0]
  def change
    create_table :agenda_laboratorista do |t|
      t.integer :laboratorista_id
      t.date :fecha
      t.time :hora_inicio
      t.time :hora_fin
      t.string :descripcion

      t.timestamps
    end
  end
end
