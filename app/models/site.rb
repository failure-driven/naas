class Site < ApplicationRecord
  validates :url, presence: true, url: true
  validates :url, length: { minimum: 10 }

  has_many :site_users, dependent: :destroy
  has_many :users, through: :site_users

  has_many :keys, dependent: :destroy
end
