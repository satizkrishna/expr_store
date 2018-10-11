class LineItem < ApplicationRecord
	#Attributes:
	# variant_id, price, final_price
	belongs_to :order
	belongs_to :variant
	has_many :order_adjustments, :as => :order_entity

	after_update :check_valid

	def check_valid
		destroy if saved_change_to_quantity? && quantity <= 0
	end

	def auto_adjust_quantity(qty)
		
	end
end
