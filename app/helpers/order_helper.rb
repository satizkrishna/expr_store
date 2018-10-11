module OrderHelper
		
	module_function

	# For Controller Actions ::
	def get_cart_data
		@cart_data = OrderBuilder.new(@current_order).build_and_get
	end

	def add_sku_to_cart(sku,quantity)
		@cart_data = OrderBuilder.new(@current_order,{:change_item => OrderBuilder::AddSku.new(sku,quantity)})
						.build_and_get
	end

	def remove_sku_from_cart(sku,quantity)
		@cart_data = OrderBuilder.new(@current_order,{:change_item => OrderBuilder::RemoveSku.new(sku,quantity)})
						.build_and_get
	end

	def apply_coupon_code(code)
		@cart_data = OrderBuilder.new(@current_order,{:change_offer => OrderBuilder::AddCoupon.new(code)})
						.build_and_get
	end

	def remove_coupon_code(code)
		@cart_data = OrderBuilder.new(@current_order,{:change_offer => OrderBuilder::RemoveCoupon.new(code)})
						.build_and_get
	end

	def complete_purchase_now
		@cart_data = OrderBuilder.new(@current_order,{:request => Order::ON_COMPLETE})
						.build_and_get
	end


end