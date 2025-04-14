class Informe < ApplicationRecord
  belongs_to :laboratorista, class_name: 'User'
  belongs_to :gerente, class_name: 'User'
  has_many :notificaciones, dependent: :destroy
  validates :codigo_solicitud, presence: true, uniqueness: true
end
