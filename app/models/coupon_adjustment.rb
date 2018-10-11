class CouponAdjustment < ApplicationRecord
	belongs_to :coupon
	# columns amount, on_item?, max_discount
	def create_adjustments_for_order(order)
		raise "Not a valid operation on this coupon adjustment!"
	end

	def get_diff_for_order(order)
		raise "Not a valid operation on this coupon adjustment!"
	end

	private
	
	def create_order_adjustment(order_entity,diff,offer)
		order = (order_entity.is_a? Order) ? order_entity : order_entity.order
		adjst = order.adjustments.where(:coupon_id => coupon.id,:order_entity => order_entity).first
		adjst = order.adjustments.new(:coupon_id => coupon.id,:order_entity => order_entity,:user_applied => offer.user_applied?) unless adjst.present?
		adjst.diff_in_sp = -(diff)
		adjst.save
	end
end
