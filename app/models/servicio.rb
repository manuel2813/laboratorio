class Servicio < ApplicationRecord
  belongs_to :laboratorista, class_name: 'User'
  has_many :costos_servicio_por_tipo_clientes, dependent: :destroy
  validates :codigo_servicio, presence: true, uniqueness: true
  validate :imagen_archivo_presence

  def imagen_archivo_presence
    errors.add(:imagen_archivo, "debe estar adjunta") unless imagen_archivo.attached?
  end

  has_one_attached :imagen_archivo
end
