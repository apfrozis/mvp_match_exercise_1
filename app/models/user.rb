class User < ApplicationRecord
  has_many :products, dependent: :destroy

  enum status: { buyer: 0, seller: 1, }
end
