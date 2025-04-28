class CostosServicioPorTipoCliente < ApplicationRecord
  belongs_to :tipo_cliente
  belongs_to :servicio, primary_key: :codigo_servicio, foreign_key: :codigo_servicio, optional: true
  validates :costo, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :codigo_servicio, uniqueness: { scope: :tipo_cliente_id, message: "ya tiene un costo asignado para este tipo de cliente" }

end
