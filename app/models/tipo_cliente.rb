class TipoCliente < ApplicationRecord
  has_many :clients
  validates :nombre, presence: true, uniqueness: true
end
