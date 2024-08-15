class Product < ApplicationRecord
  has_one_attached :photo
  has_many :order_items

  def self.ransackable_attributes(auth_object = nil)
    ["name", "price","total_quantity"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["photo_attachment", "photo_blob"]
  end
end
