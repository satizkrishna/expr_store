class OrderAdjustment < ApplicationRecord
	belongs_to :order
	belongs_to :coupon
	belongs_to :order_entity, polymorphic: true 
end
