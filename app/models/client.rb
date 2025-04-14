class Client < ApplicationRecord
  validates :codigo_muestra, presence: true, uniqueness: true
  validates :password, presence: true
end
