class Price < ApplicationRecord
	#Attributes:
	# variant_id, mrp, sp
	belongs_to :variant
end
