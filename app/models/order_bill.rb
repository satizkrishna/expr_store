class OrderBill < ApplicationRecord
	#Attributes:
	# order_id, bill_copy
	belongs_to :order

	def create_now
		
	end
end
