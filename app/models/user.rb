class User < ApplicationRecord

  has_many :products, dependent: :destroy

  scope :buyer, -> { where(role: :buyer) }

  scope :seller, -> { where(role: :seller) }

  def authenticate(password)
    self.password == password
  end
end
