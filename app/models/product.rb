class Product < ApplicationRecord
  belongs_to :user

  validate :multiple_of_5?


  private

  def multiple_of_5?
    multiple_of_5 = self.cost % 5 == 0 && self.cost != 0

    errors.add :cost, 'Product cost must be multiple of 5' unless multiple_of_5
  end
end
