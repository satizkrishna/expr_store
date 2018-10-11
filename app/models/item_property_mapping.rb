class ItemPropertyMapping < ApplicationRecord
	belongs_to :item
	belongs_to :item_property_value
end
