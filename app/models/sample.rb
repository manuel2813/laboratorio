class Sample < ApplicationRecord
  self.table_name = "samples"

  # Relaciones
  belongs_to :laboratorista, class_name: "User", foreign_key: "laboratorista_id"
  belongs_to :user, optional: true  # Ya no obligatorio
  belongs_to :servicio, optional: true  # Ya no obligatorio

  # Validaciones
  validates :code, presence: true, uniqueness: true
  validates :results, presence: true

  # Puedes agregar validaciones opcionales si lo deseas, por ejemplo:
  # validates :numero_muestras, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
end
