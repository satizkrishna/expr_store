class CouponRule::UserCouponRule < CouponRule
	
	# columns: check_column, operator, expected_value

	def self.get_columns_for_create
		get_additional_columns
	end

	def self.get_additional_columns
		['user.nth_order','user.nth_day','user.group']
	end
	
	def eligible? order
		if check_column.in? self.class.get_columns_for_create
			begin
				op1 = eval(check_column)
			rescue SyntaxError => se
				op1 = send("do_"+ check_column.gsub('.','_'),line_item,order)
			end
			op2 = expected_value
			opr = operator
			self.class.perform_opr(op1,op2,opr)
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

	private

	def do_user_nth_order order
		order.user.orders.count
	end

	def do_user_nth_order order
		(Date.today - order.user.created_at.to_date).to_i
	end

	def do_user_group order
		order.user.user_groups.pluck(:name)
	end
end

end
