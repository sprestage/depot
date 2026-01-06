class LineItem < ApplicationRecord
  belongs_to :product
  belongs_to :cart

  validates :quantity, numericality: {
    only_integer: true,
    greater_than: 0,
    message: "must be a positive number"
  }
  validates :price, numericality: {
    greater_than_or_equal_to: 0.01,
    message: "must be at least $0.01"
  }

  def total_price
    product.price * quantity
  end
end
