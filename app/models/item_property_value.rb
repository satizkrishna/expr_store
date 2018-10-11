class ItemPropertyValue < ApplicationRecord
	#Attributes:
	# name, description, item_property_id
	belongs_to :item_property
	has_and_belongs_to_many :items, :join_table => :item_property_mapping 
end
