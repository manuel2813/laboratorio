class Compra < ApplicationRecord
  belongs_to :servicio
  belongs_to :cliente
end
