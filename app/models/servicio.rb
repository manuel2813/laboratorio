class Servicio < ApplicationRecord
  belongs_to :laboratorista, class_name: 'User'
  has_many :costos_servicio_por_tipo_clientes, dependent: :destroy

  # Validación del código del servicio
  validates :codigo_servicio, presence: true, uniqueness: true
  
  # Validación para asegurar que la imagen está adjunta
  validate :imagen_archivo_presence

  # Lógica para validar si la imagen está adjunta
  def imagen_archivo_presence
    errors.add(:imagen_archivo, "debe estar adjunta") unless imagen_archivo.attached?
  end

  # Asociamos la imagen al servicio
  has_one_attached :imagen_archivo

  # Método para mostrar la imagen en la vista show
  def display_imagen
    if imagen_archivo.attached?
      url_for(imagen_archivo)
    else
      "https://via.placeholder.com/600x400.png?text=Sin+Imagen"
    end
  end
end
