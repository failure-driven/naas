class Notification < ApplicationRecord
  def data=(value)
    self[:data] = value.is_a?(String) ? JSON.parse(value) : value
  end
end
