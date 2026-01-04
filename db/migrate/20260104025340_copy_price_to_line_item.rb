class CopyPriceToLineItem < ActiveRecord::Migration[8.0]
  def up
    LineItem.reset_column_information
    LineItem.all.each do |line_item|
      line_item.update_column(:price, line_item.product.price)
    end
  end

  def down
    LineItem.update_all(price: nil)
  end
end
