class ProductSerializer
  class << self
    def record(product)
      { name: product.name, amount_available: product.amount_available, cost: product.cost,
        user_name: product.user.name }
    end

    def collection(products)
      products.map { |product| record(product) }
    end
  end
end