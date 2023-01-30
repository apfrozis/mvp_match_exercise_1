class User < ApplicationRecord
  has_many :products

  enum status: { buyer: 0, seller: 1, }
end
