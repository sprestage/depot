require "test_helper"

class LineItemTest < ActiveSupport::TestCase
  test "line item quantity must be positive" do
    line_item = LineItem.new(product: products(:one), cart: carts(:one), price: 9.99)

    line_item.quantity = 0
    assert line_item.invalid?
    assert_equal "must be a positive number", line_item.errors[:quantity].first

    line_item.quantity = -1
    assert line_item.invalid?
    assert_equal "must be a positive number", line_item.errors[:quantity].first

    line_item.quantity = 1
    assert line_item.valid?
  end

  test "line item price must be at least 0.01" do
    line_item = LineItem.new(product: products(:one), cart: carts(:one), quantity: 1)

    line_item.price = 0
    assert line_item.invalid?
    assert_equal "must be at least $0.01", line_item.errors[:price].first

    line_item.price = -1
    assert line_item.invalid?
    assert_equal "must be at least $0.01", line_item.errors[:price].first

    line_item.price = 0.01
    assert line_item.valid?
  end

  test "line item quantity must be integer" do
    line_item = LineItem.new(product: products(:one), cart: carts(:one), price: 9.99)

    line_item.quantity = 1.5
    assert line_item.invalid?
    assert_includes line_item.errors[:quantity], "must be a positive number"
  end
end
