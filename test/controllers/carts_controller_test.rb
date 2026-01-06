require "test_helper"

class CartsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get carts_url
    assert_response :success
  end

  test "should get new" do
    get new_cart_url
    assert_response :success
  end

  test "should create cart" do
    assert_difference("Cart.count") do
      post carts_url, params: { cart: {} }
    end

    assert_redirected_to cart_url(Cart.last)
  end

  test "should show cart" do
    # Post to line_items creates a cart automatically
    post line_items_url, params: { product_id: Product.first.id }
    cart = Cart.find(session[:cart_id])
    # Now test showing the cart
    get cart_url(cart)
    assert_response :success
  end

  test "should not show cart for different user" do
    cart = Cart.create!
    other_cart = Cart.create!
    # Create a line item to initialize session
    post line_items_url, params: { product_id: Product.first.id }
    session[:cart_id] = other_cart.id
    get cart_url(cart)
    assert_redirected_to store_index_url
    assert_equal "You can only access your own cart", flash[:notice]
  end

  test "should get edit" do
    # Post to line_items creates a cart and initializes session
    post line_items_url, params: { product_id: Product.first.id }
    cart = Cart.find(session[:cart_id])
    get edit_cart_url(cart)
    assert_response :success
  end

  test "should not get edit for different user cart" do
    cart = Cart.create!
    other_cart = Cart.create!
    # Create a line item to initialize session
    post line_items_url, params: { product_id: Product.first.id }
    session[:cart_id] = other_cart.id
    get edit_cart_url(cart)
    assert_redirected_to store_index_url
    assert_equal "You can only access your own cart", flash[:notice]
  end

  test "should update cart" do
    # Post to line_items creates a cart and initializes session
    post line_items_url, params: { product_id: Product.first.id }
    cart = Cart.find(session[:cart_id])
    patch cart_url(cart), params: { cart: {} }
    assert_redirected_to cart_url(cart)
  end

  test "should not update different user cart" do
    cart = Cart.create!
    other_cart = Cart.create!
    # Create a line item to initialize session
    post line_items_url, params: { product_id: Product.first.id }
    session[:cart_id] = other_cart.id
    patch cart_url(cart), params: { cart: {} }
    assert_redirected_to store_index_url
    assert_equal "You can only access your own cart", flash[:notice]
  end

  test "should destroy cart" do
    product = Product.find_by(title: "The Pragmatic Programmer")
    post line_items_url, params: { product_id: product.id }
    cart_id = session[:cart_id]

    assert_difference("Cart.count", -1) do
      delete cart_url(cart_id)
    end

    assert_redirected_to store_index_url
  end

  test "should not destroy different user cart" do
    cart = Cart.create!
    other_cart = Cart.create!
    # Create a line item to initialize session
    post line_items_url, params: { product_id: Product.first.id }
    session[:cart_id] = other_cart.id

    assert_no_difference("Cart.count") do
      delete cart_url(cart)
    end

    assert_redirected_to store_index_url
    assert_equal "You can only access your own cart", flash[:notice]
  end

  test "should handle invalid cart gracefully" do
    get cart_url(id: 99999)
    assert_redirected_to store_index_url
    assert_equal "Invalid cart", flash[:notice]
  end
end
