class User < ApplicationRecord
  # Asociaciones existentes
  has_many :samples, foreign_key: :user_id, dependent: :destroy
  has_many :assigned_samples, class_name: 'Sample', foreign_key: :laboratorista_id, dependent: :destroy

  # Nuevas asociaciones según tu esquema
  has_many :notificaciones, foreign_key: :cliente_id, dependent: :destroy
  has_many :informes_como_laboratorista, class_name: 'Informe', foreign_key: :laboratorista_id, dependent: :destroy
  has_many :informes_como_gerente, class_name: 'Informe', foreign_key: :gerente_id, dependent: :destroy

  # Relación opcional con TipoCliente (si aplica)
  belongs_to :tipo_cliente, optional: true, foreign_key: :tipo_cliente_id

  # Roles de usuario
  enum role: { cliente: 0, laboratorista: 1, admin: 2, gerente: 3 }

  # Devise módulos para autenticación
  devise :database_authenticatable, :recoverable, :rememberable, :validatable

  # Validaciones
  validates :email, presence: true, uniqueness: { case_sensitive: false, message: 'El correo ya está registrado.' }
  validates :password, presence: true, confirmation: true, length: { minimum: 6 }, if: :password_required?
  validates :role, presence: true, inclusion: { in: roles.keys, message: 'El rol no es válido.' }

  # Validación opcional para clientes si tienen un tipo asignado
  validates :tipo_cliente, presence: true, if: -> { cliente? }
  # Privado
  private

  def password_required?
    new_record? || password.present?
  end
end