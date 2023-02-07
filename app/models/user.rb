class User < ApplicationRecord
  has_many :products, dependent: :destroy
  has_many :sessions, dependent: :destroy

  validates_uniqueness_of :username

  scope :buyer, -> { where(role: :buyer) }

  scope :seller, -> { where(role: :seller) }

  def authenticate(password)
    self.password == password
  end
end
