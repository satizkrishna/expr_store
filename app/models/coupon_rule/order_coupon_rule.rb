class CouponRule::OrderCouponRule < CouponRule
	
	# columns: check_column, operator, expected_value

	def self.get_columns_for_create
		get_additional_columns + self.get_order_fields.reject { |key|  !(key.to_s.include? "order.") }
	end

	def self.get_additional_columns
		[]
	end
	
	def eligible? order
		if check_column.in? self.class.get_columns_for_create
			self.class.perform_opr(eval(check_column),expected_value,operator.to_i)
		else
			false
		end
	end

	def get_eligible_line_items order
		if eligible? order
			order.line_items
		else
			[]
		end
	end
end
