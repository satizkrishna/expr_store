class ItemProperty < ApplicationRecord
	#Attributes:
	# name, description
	has_many :item_property_values
	
end
