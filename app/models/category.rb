class Category < ApplicationRecord
	#Attributes:
	# name, description
	
	has_and_belongs_to_many :items, :join_table => :item_category_mappings 

end
