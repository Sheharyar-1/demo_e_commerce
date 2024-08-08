class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # , :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :confirmable

  validates :password, length: { maximum: 10 }
  validate :password_special_character

  enum role: {user: 0, staff: 1, admin: 2}
  
  after_initialize :set_default_role, :if => :new_record?

  def set_default_role
    self.role ||= :user
  end

  private

  def password_special_character
    return if password.blank?

    unless password.match?(/[^a-zA-Z0-9]/)
      errors.add :password, "must include at least one special character"
    end
  end
end
