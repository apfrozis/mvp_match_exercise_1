class User < ApplicationRecord
  has_many :products, dependent: :destroy

  enum status: { buyer: 0, seller: 1, }

  scope :buyer, -> { where(role: 0) }

  scope :seller, -> { where(role: 1) }
end
