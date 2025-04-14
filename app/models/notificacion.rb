class Notificacion < ApplicationRecord
  belongs_to :client
  belongs_to :informe, optional: true
  validates :mensaje, presence: true
end
