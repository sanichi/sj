class User < ApplicationRecord
  has_secure_password

  MAX_NAME = 20
  MAX_HANDLE = 20
  MIN_HANDLE = 2
  MIN_PASSWORD = 6

  before_validation :normalize_attributes

  validates :handle,
    format: { with: /\A[a-z]\w+\z/i },
    length: { minimum: MIN_HANDLE, maximum: MAX_HANDLE },
    uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: MIN_PASSWORD }, allow_nil: true
  validates :first_name, format: { with: /\A[A-Z][a-z]+\z/ }
  validates :last_name, format: { with: /\A(O'|Mac|Mc)?[A-Z][a-z]+\z/ }

  def admin?
    admin
  end

  def guest?
    false
  end

  def name
    "#{first_name} #{last_name}"
  end

  def handle_extra
    "#{handle}#{admin ? '†' : ''}"
  end

  private

  def normalize_attributes
    first_name&.squish!
    last_name&.squish!
    handle&.squish!
  end
end
