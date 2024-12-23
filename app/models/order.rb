class Order < ApplicationRecord
  belongs_to :user
  has_many :ordered_lists
  has_many :items, through: :ordered_lists
  accepts_nested_attributes_for :ordered_lists

  def update_total_quantity
    # Encapsule la mise à jour dans une transaction
    Item.transaction do
      self.ordered_lists.each do |line_item|
        item = Item.find_by(id: line_item.item_id)
        item.with_lock do
          item.total_quantity += line_item.quantity
          item.save!
        end
      end
    end
  end
end
