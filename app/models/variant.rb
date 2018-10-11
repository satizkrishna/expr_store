class Variant < ApplicationRecord
	#Attributes:
	# sku, item_id, 
	
	belongs_to :item
	has_one :price,:dependent => :destroy 
	has_one :item_asset,:dependent => :destroy 

	after_update :update_item_stock

	def change_stock_after_bill(qty)
		count_on_hand -= qty
	end

	def quantity_available?(qty)
		count_on_hand >= qty
	end

	def available?
		item.live?
	end

	private 
	
	def update_item_stock
		if saved_change_to_count_on_hand?
			item.count_on_hand = item.variants.all.pluck(:count_on_hand).reduce(0,:+)
			item.save
		end
	end
end
