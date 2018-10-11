class Item < ApplicationRecord
	#Attributes:
	# name, description, base_price
	
	has_many :variants, :dependent => :destroy 
	has_and_belongs_to_many :categories, :join_table => :item_category_mappings
	has_and_belongs_to_many :item_property_values, :join_table => :item_property_mappings

	scope :with_page_info, -> { 
		includes([:variants => [:price,:item_asset]]).
		includes(:categories).
		includes(:item_property_values)
	}
	scope :active, -> { where(state: Item::LIVE) } 
	scope :in_stock, -> { where(count_on_hand: 1..Float::INFINITY) }  
	scope :recent_first, -> { order(created_at: :desc) }

	before_update :update_item_stock

	def live?
		(state == Item::LIVE) && (count_on_hand > 0)
	end

	def update_item_stock
		on_hand = variants.pluck(:count_on_hand).reduce(0,:+)
		count_on_hand = on_hand
	end
	
end
