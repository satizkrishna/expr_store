class CouponRule < ApplicationRecord
	belongs_to :coupon

	# columns: parameter1, operator, expected_value
	def eligible? order
		raise "Not a valid operation on this coupon rule!"
	end

	def self.get_columns_for_create
		raise "Not a valid operation on this coupon rule!"
	end

	def self.get_additional_columns
		raise "Not a valid operation on this coupon rule!"
	end

	def get_eligible_line_items
		raise "Not a valid operation on this coupon rule!"
	end

	def self.get_order_fields
		fields = []
		order_build = OrderBuilder.new.build_and_get
		order_build.to_h.each{|key,value|
			next if key.in? [:coupons, :adjustments, :eligible_offers, :bill, :errors, :request_state, :id, :number, :state]
			if !(value.is_a? Array)
				fields << 'order.'+ key.to_s 
			elsif (value.first.is_a? OrderUtil::LineItemBuild)
				value.first.to_h.keys.each{|li_key|
					next if li_key.in? [:id, :sku, :image_url]
					fields << 'line_item.'+ li_key.to_s 
				}
			end
		}
		fields
	end

	def self.perform_opr(op1,op2,opr)
    	begin
	    	case opr 
		    	when Coupon::STARTS_WITH
					op1.start_with? op2
				when Coupon::ENDS_WITH
					op1.end_with? op2
				when Coupon::EQUALS
					op1.eql? op2
				when Coupon::MATCHES
					op1.include? op2
				when Coupon::INCLUDES
					op1.include? op2
				when Coupon::EXISTS
					op1.present?
				when Coupon::IN_SET
					op1.to_s.in? op2.split(',')
				when Coupon::NOT_STARTS_WITH
					!(op1.start_with? op2)
				when Coupon::NOT_ENDS_WITH
					!(op1.end_with? op2)
				when Coupon::NOT_EQUALS
					!(op1.eql? op2)
				when Coupon::NOT_MATCHES
					!(op1.include? op2)
				when Coupon::NOT_INCLUDES
					!(op1.include? op2)
				when Coupon::NOT_EXISTS
					!op1.present?
				when Coupon::NOT_IN_SET
					!(op1.to_s.in? op2.split(','))
				when Coupon::GREATER_THAN
					op1.to_i > op2.to_i
				when Coupon::LESS_THAN
					op1.to_i < op2.to_i
				when Coupon::GREATER_OR_EQUALS
					op1.to_i >= op2.to_i
				when Coupon::LESS_OR_EQUALS
					op1.to_i <= op2.to_i
				when Coupon::BETWEEN
					op1.between(op2[0].to_i,op2[1].to_i)
				else
					false
			end	
		rescue 
			false
    	end	
	end

end
