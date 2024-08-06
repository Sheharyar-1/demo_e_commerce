class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable



  validates :password, length: { maximum: 10 }

  validate :password_special_character

  private

  def password_special_character
    return if password.blank?

    unless password.match?(/[^a-zA-Z0-9]/)
      errors.add :password, "must include at least one special character"
    end
  end
end
