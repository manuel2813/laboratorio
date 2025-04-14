class CostosServicioPorTipoCliente < ApplicationRecord
  belongs_to :tipo_cliente
  validates :costo, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
