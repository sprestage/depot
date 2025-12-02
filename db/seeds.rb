# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
Product.delete_all

product = Product.create(title: 'Kai and siblings',
                         description:
                           %(<p>
<em>Kai and his two young siblings</em>
A brief description of Kai and his two young siblings.
</p>),
                         price: 50.95)
product.image.attach(io: File.open(
  Rails.root.join('db', 'images', 'IMG_6791.JPG')),
                     filename: 'IMG_6791.JPG')
product.save!

product = Product.create(title: 'Dorin',
                         description:
                           %(<p>
<em>Trakehner inspection - Dorin</em>
A lovely head shot of Dorin at her inspection.
</p>),
                         price: 30.95)
product.image.attach(io: File.open(
  Rails.root.join('db', 'images', 'trakehnerInspectionDorinLovelyHead.jpg')),
                     filename: 'trakehnerInspectionDorinLovelyHead.jpg')
product.save!
