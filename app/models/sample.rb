class Sample < ApplicationRecord
  self.table_name = "samples"
  
  belongs_to :laboratorista, class_name: "User", foreign_key: "laboratorista_id"
  belongs_to :user
  belongs_to :servicio, optional: true # Nuevo campo: servicio_id

  validates :code, presence: true, uniqueness: true
  validates :results, presence: true
end
