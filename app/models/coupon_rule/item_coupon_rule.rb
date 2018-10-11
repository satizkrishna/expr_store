class CouponRule::ItemCouponRule < CouponRule
	
	# columns: check_column, operator, expected_value

	def self.get_columns_for_create
		get_additional_columns + self.get_order_fields.reject { |key|  !(key.include? "line_item.") }
	end

	def self.get_additional_columns
		['line_item.category','line_item.property']
	end
	
	def eligible? order
		order.line_items.each{|line_item|
			li_eligible? line_item
		}.any?
	end

	def get_eligible_line_items order
		order.line_items.reject{|line_item|
			li_eligible? line_item
		}
	end

	private

	def li_eligible?(line_item)
		if check_column.in? self.class.get_columns_for_create
			begin
				op1 = eval(check_column)
			rescue SyntaxError => se
				op1 = send("do_"+ check_column.gsub('.','_'),line_item)
			end
			op2 = expected_value
			opr = operator
			self.class.perform_opr(op1,op2,opr)
		else
			false
		end		
	end

	def do_line_item_category(line_item)
		line_item.variant.item.categories.pluck(:name)
	end

	def do_line_item_property(line_item)
		line_item.variant.item.item_property_values.pluck(:name)
	end
end
