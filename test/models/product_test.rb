#---
# Excerpted from "Agile Web Development with Rails 8",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit https://pragprog.com/titles/rails8 for more book information.
#---
require "test_helper"

class ProductTest < ActiveSupport::TestCase
  test "product attributes must not be empty" do
    product = Product.new
    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:price].any?
    assert product.errors[:image].any?
  end

  test "product price must be positive" do
    product = Product.new(title:       "My Book Title",
                          description: "yyy")
    product.image.attach(io: File.open("test/fixtures/files/lorem.jpg"),
                         filename: "lorem.jpg", content_type: "image/jpeg")
    product.price = -1
    assert product.invalid?
    assert_equal [ "must be at least $0.01" ],
                 product.errors[:price]

    product.price = 0
    assert product.invalid?
    assert_equal [ "must be at least $0.01" ],
                 product.errors[:price]

    product.price = 1
    assert product.valid?
  end

  def new_product(filename, content_type)
    Product.new(
      title:       "My Book Title",
      description: "yyy",
      price:       1
    ).tap do |product|
      product.image.attach(
        io: File.open("test/fixtures/files/#{filename}"), filename:, content_type:)
    end
  end

  test "image url" do
    product = new_product("jori_2011_inspection_head4_cropped.jpg", "image/jpeg")
    assert product.valid?, "image/jpeg must be valid"

    product = new_product("Orquideas_Logo2_small.tif", "image/tiff")
    assert_not product.valid?, "image/tiff must be invalid"
  end

  test "product is not valid without a unique title" do
    product = Product.new(title:       products(:pragprog).title,
                          description: "yyy",
                          price:       1)
    product.image.attach(io: File.open("test/fixtures/files/lorem.jpg"),
                         filename: "lorem.jpg", content_type: "image/jpeg")

    assert product.invalid?
    assert_equal [ "has already been taken" ], product.errors[:title]
  end

  test "product is not valid without a unique title - i18n" do
    product = Product.new(title:       products(:pragprog).title,
                          description: "yyy",
                          price:       1)

    product.image.attach(io: File.open("test/fixtures/files/lorem.jpg"),
                         filename: "lorem.jpg", content_type: "image/jpeg")


    assert product.invalid?
    assert_equal [ I18n.translate("errors.messages.taken") ],
                 product.errors[:title]
  end

  test "product cannot be deleted if it has line items" do
    product = products(:pragprog)
    # pragprog fixture has line items associated with it
    assert_not product.destroy
    assert_not_empty product.errors[:base]
    assert_equal "Cannot delete product that is in someone's cart", product.errors[:base].first
  end

  test "product can be deleted if it has no line items" do
    product = products(:one)
    product.line_items.destroy_all  # Ensure no line items
    assert product.destroy
  end

  test "image must be acceptable type" do
    product = Product.new(title: "Test", description: "Test", price: 9.99)
    product.image.attach(io: File.open(Rails.root.join("test/fixtures/files/pomodoro.pdf")),
                        filename: "pomodoro.pdf", content_type: "application/pdf")
    assert product.invalid?
    assert_equal "must be a GIF, JPG or PNG image", product.errors[:image].first
  end
end
