class Key < ApplicationRecord
  validates :key, length: { minimum: 10 }
  validates :secret, length: { minimum: 10 }

  belongs_to :site

  def self.generate_key_for(site)
    site.keys.new(
      key: SecureRandom.base64(15),
      secret: SecureRandom.base64(15),
    )
  end
end
