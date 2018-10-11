module OrderUtil
	

	NullInstance = Struct.new(:instance)
	OrderInstance = Struct.new(:instance)
	OrderBuild = Struct.new(:id,:number,:state,:total_price,:final_price,:line_items,:coupons,:adjustments,:eligible_offers,:bill,:errors,:request_state)
	LineItemBuild = Struct.new(:id,:sku,:mrp,:quantity,:sp,:final_price,:display_string,:image_url)
	CouponBuild = Struct.new(:id,:code)
	AdjustmentBuild = Struct.new(:id,:coupon_code,:description,:diff_in_sp)
	BillBuild = Struct.new(:id,:data)
	AddSku = Struct.new(:sku,:quantity)
	RemoveSku = Struct.new(:sku,:quantity)
	AddCoupon = Struct.new(:code)
	RemoveCoupon = Struct.new(:code)
	EligibleOffer = Struct.new(:code,:user_applied?,:piggy_back,:auto_apply,:diff_price)
	OrderError = Struct.new(:error,:message)
	OrderState = Struct.new(:value)

	class OrderPayloadInstanceBuilder
		def self.build(instance)
			if instance.is_a?(Order)	
				OrderInstance.new(instance)
			else
				NullInstance.new(instance)
			end
		end
	end

end



