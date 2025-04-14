class Sample < ApplicationRecord
  self.table_name = "samples" # No cambia el nombre de la tabla, pero lo interpretamos como solicitudes

  belongs_to :laboratorista, class_name: "User", foreign_key: "laboratorista_id"
  belongs_to :user
  belongs_to :tenant

  validates :code, presence: true, uniqueness: true
  validates :results, presence: true
end

