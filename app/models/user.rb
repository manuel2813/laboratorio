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
  devise :database_authenticatable, :recoverable, :rememberable, :validatable, :registerable

  # Validaciones
  validates :email, presence: true, uniqueness: { case_sensitive: false, message: 'El correo ya está registrado.' }
  validates :password, presence: true, confirmation: true, length: { minimum: 6 }, if: :password_required?
  validates :role, presence: true, inclusion: { in: roles.keys, message: 'El rol no es válido.' }

  # Validación opcional para clientes si tienen un tipo asignado
  validates :tipo_cliente, presence: true, if: -> { cliente? }

before_create :generate_verification_code
after_create :send_verification_email

VALID_EMAIL_DOMAINS = ['gmail.com', 'hotmail.com', 'unas.edu.pe']

validate :email_domain_allowed

def generate_verification_code
  self.verification_code = rand(100000..999999).to_s
  self.verified = false
end

def send_verification_email
  return unless email_domain_allowed?

  UserMailer.with(user: self).verification_email.deliver_later
end

def email_domain_allowed?
  VALID_EMAIL_DOMAINS.any? { |d| email.ends_with?("@#{d}") }
end

def email_domain_allowed
  unless email_domain_allowed?
    errors.add(:email, "debe ser @gmail.com, @hotmail.com o @unas.edu.pe")
  end
end

  private

  def password_required?
    new_record? || password.present?
  end

end