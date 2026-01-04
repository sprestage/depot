require "test_helper"

class CartTest < ActiveSupport::TestCase
  test "adding unique products to cart" do
    cart = Cart.create
    product_one = products(:one)
    product_two = products(:two)

    cart.add_product(product_one).save!
    cart.add_product(product_two).save!

    assert_equal 2, cart.line_items.size
    assert_equal 1, cart.line_items.find_by(product: product_one).quantity
    assert_equal 1, cart.line_items.find_by(product: product_two).quantity
  end

  test "adding duplicate products to cart increases quantity" do
    cart = Cart.create
    product = products(:pragprog)

    cart.add_product(product).save!
    cart.add_product(product).save!
    cart.add_product(product).save!

    assert_equal 1, cart.line_items.size
    assert_equal 3, cart.line_items.first.quantity
  end

  test "adding mix of unique and duplicate products" do
    cart = Cart.create
    product_one = products(:one)
    product_pragprog = products(:pragprog)

    cart.add_product(product_one).save!
    cart.add_product(product_pragprog).save!
    cart.add_product(product_one).save!

    assert_equal 2, cart.line_items.size
    assert_equal 2, cart.line_items.find_by(product: product_one).quantity
    assert_equal 1, cart.line_items.find_by(product: product_pragprog).quantity
  end
end
