class Product < ApplicationRecord
  has_many :line_items
  before_destroy :ensure_not_referenced_by_any_line_item
  has_one_attached :image
  after_commit -> { broadcast_refresh_later_to "products" }

  validates :title, :description, :image, presence: true
  validates :title, uniqueness: true
  validates :price, numericality: {
    greater_than_or_equal_to: 0.01,
    message: "must be at least $0.01"
  }
  validate :acceptable_image

  def acceptable_image
    return unless image.attached?
    acceptable_types = [ "image/gif", "image/jpeg", "image/png" ]
    unless acceptable_types.include?(image.content_type)
      errors.add(:image, "must be a GIF, JPG or PNG image")
    end
  end

  private

  def ensure_not_referenced_by_any_line_item
    unless line_items.empty?
      errors.add(:base, "Cannot delete product that is in someone's cart")
      throw :abort
    end
  end
end
