class CouponAdjustment::FlatPercentAdjustment < CouponAdjustment
	def create_adjustments_for_order(order,offer)
		if on_item
			coupon.eligible_line_items.each{|li|
			max_diff = (li.final_price * (amount/100.0))
			final = (max_diff > max_discount) ? max_discount : max_diff
			final_diff = (final > li.final_price) ? li.final_price : final
			create_order_adjustment(li,final_diff)
			}
		else
			max_diff = (order.final_price * (amount/100.0))
			final = (max_diff > max_discount) ? max_discount : max_diff
			final_diff = (final > order.final_price) ? order.final_price : final
			create_order_adjustment(order,final_diff,offer)
		end
	end

	def get_diff_for_order(order)
		if on_item
			coupon.eligible_line_items.each{|li|
			max_diff = (li.final_price * (amount/100.0))
			final = (max_diff > max_discount) ? max_discount : max_diff
			(final > order.final_price) ? order.final_price : final
			}.reduce(0,:+)
		else
			max_diff = (order.final_price * (amount/100.0))
			final = (max_diff > max_discount) ? max_discount : max_diff
			(final > order.final_price) ? order.final_price : final
		end
		
	end
end
