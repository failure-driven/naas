class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :timeoutable, :trackable

  has_many :site_users
  has_many :sites, through: :site_users

  def user_actions=(value)
    self[:user_actions] = value.is_a?(String) ? JSON.parse(value) : value
  end
end
