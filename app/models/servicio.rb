class Servicio < ApplicationRecord
  belongs_to :laboratorista, class_name: 'User'
  has_many :costos_servicio_por_tipo_clientes, dependent: :destroy
  validates :codigo_servicio, presence: true, uniqueness: true
  validates :imagen_archivo, presence: true
  has_one_attached :imagen_archivo
end
