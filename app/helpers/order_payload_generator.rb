class OrderPayloadGenerator
	# TODO: Create OrderException class and throw Exceptions to provide detailed failure responses.
	include OrderUtil
	include OrderHelper

	@builder = nil

	def initialize(builder)
		@builder = builder if builder.is_a? OrderBuilder
	end

	def do_op(action, instance)
		# handle exeptions for call without OrderBuilder //leaving for now!!
		send("#{action.to_s}_on_#{instance.class.to_s.demodulize.underscore}".to_sym)	
	end
	
	private 

	def get_order_construct_from_builder
		@builder.get_order_construct
	end

	def get_order_from_builder
		@builder.get_order
	end

	def get_options_from_builder
		@builder.get_options
	end

	def set_order_construct_through_builder(order_construct)
		@builder.set_order_construct(order_construct)
	end

	def find_best_offers_on_null_instance
		this_order_construct = get_order_construct_from_builder
		this_order_construct.eligible_offers ||= []
		this_order_construct.eligible_offers << EligibleOffer.new("BLUFF",false)
		set_order_construct_through_builder(this_order_construct)
	end
	
	def find_best_offers_on_order_instance
		this_options = get_options_from_builder
		if this_options[:change_offer].present? && this_options[:change_offer].is_a?(AddCoupon) && !Coupon.find_by(:code => this_options[:change_offer].code).present?
			this_order_construct = get_order_construct_from_builder
			this_order_construct.errors ||= []
			this_order_construct.errors << OrderError.new("Failed Add Coupon","Coupon not found")
			set_order_construct_through_builder(this_order_construct)
		end
		# check eligible offers for the order and select matching offers. - def get_applied_offers and get_eligible_offers @ order.rb // instance method
		eligible_offers = (get_order_construct_from_builder.request_state.value == Order::ON_COMPLETE)	?
							get_order_from_builder.get_applied_offers	:
							get_order_from_builder.get_eligible_offers(get_options_from_builder)
		
		puts "::::::::::::::::::::::::::::::::::::::::::ELIGIBLE OFFERS!!!!"
		puts eligible_offers
		this_order_construct = get_order_construct_from_builder
		this_order_construct.eligible_offers ||= []
		this_order_construct.eligible_offers += eligible_offers
		set_order_construct_through_builder(this_order_construct)
	end		

	def with_order_data_on_null_instance
		this_order_construct = get_order_construct_from_builder
		this_order_construct.id = 0
		this_order_construct.number = "O-0000000000"
		this_order_construct.state = Order::CART
		this_order_construct.total_price = 0.00
		this_order_construct.final_price = 0.00	
		set_order_construct_through_builder(this_order_construct)
	end

	
	def with_order_data_on_order_instance
		this_order_construct = get_order_construct_from_builder
		this_order_construct.id = get_order_from_builder.id
		this_order_construct.number = get_order_from_builder.number
		this_order_construct.state = get_order_from_builder.state
		this_order_construct.total_price = get_order_from_builder.total_price
		this_order_construct.final_price = get_order_from_builder.final_price
		set_order_construct_through_builder(this_order_construct)
	end
	
	def with_line_items_data_on_null_instance
		li_build = LineItemBuild.new
		li_build.id = 0
		li_build.sku = "AAA-000"
		li_build.mrp = 0.0
		li_build.sp = 0.0
		li_build.final_price = 0.0
		li_build.display_string = "R"
		li_build.image_url = ""
		this_order_construct = get_order_construct_from_builder
		this_order_construct.line_items ||= []
		this_order_construct.line_items << li_build
		set_order_construct_through_builder(this_order_construct)
	end
	
	def with_line_items_data_on_order_instance
		# Handle Cart actions on item level and update the data for the same
		this_order_construct = get_order_construct_from_builder
		this_order = get_order_from_builder
		if (this_order_construct.request_state.value != Order::ON_COMPLETE) && get_options_from_builder[:change_item].present?
			if (get_options_from_builder[:change_item].is_a? OrderUtil::AddSku)
				# Add line item to order, DB level only - def add_line_item @ Order.rb // instance method 
				this_order_construct.errors ||= []
				this_order_construct.errors += this_order.add_line_item(get_options_from_builder[:change_item].sku,get_options_from_builder[:change_item].quantity)
			elsif (get_options_from_builder[:change_item].is_a? OrderUtil::RemoveSku)
				# Remove line item from order, DB level only - def remove_line_item @ Order.rb // instance method
				this_order_construct.errors ||= []
				this_order_construct.errors += this_order.remove_line_item(get_options_from_builder[:change_item].sku,get_options_from_builder[:change_item].quantity)
			end
			set_order_construct_through_builder(this_order_construct)
		end
		this_order.save
		get_order_from_builder.line_items.each{|li|
			li_build = LineItemBuild.new
			li_build.id = li.id
			li_build.sku = li.variant.sku
			li_build.quantity = li.quantity
			li_build.mrp = li.mrp
			li_build.sp = li.sp
			li_build.final_price = li.variant.price.sp
			li_build.display_string = li.variant.display_str
			li_build.image_url = li.variant.item_asset.image_url
			this_order_construct = get_order_construct_from_builder
			this_order_construct.line_items ||= []
			this_order_construct.line_items << li_build
			set_order_construct_through_builder(this_order_construct)
		}
	end

	def with_order_offers_on_null_instance
		adj_build = AdjustmentBuild.new
		adj_build.id = 0
		adj_build.coupon_code = "BLUFF"
		adj_build.description = "NO DESC"
		adj_build.diff_in_sp = -0.00
		this_order_construct = get_order_construct_from_builder
		this_order_construct.adjustments ||= []
		this_order_construct.adjustments << adj_build
		set_order_construct_through_builder(this_order_construct)
	end
	
	def with_order_offers_on_order_instance

		this_order_construct = get_order_construct_from_builder
		this_order = get_order_from_builder
		if (this_order_construct.request_state.value != Order::ON_COMPLETE) && (get_options_from_builder[:change_offer].is_a? RemoveCoupon)
			this_order.remove_adjustment_for(get_options_from_builder[:change_offer].code)
			this_order_construct.eligible_offers = this_order_construct.eligible_offers.delete_if{|offer| offer.code == get_options_from_builder[:change_offer].code}
			set_order_construct_through_builder(this_order_construct)
		end
		this_order.save
		this_order_construct = get_order_construct_from_builder
		
		this_order_construct.eligible_offers.each{|offer|
			this_order.create_adjustment_for(offer)
		} if this_order_construct.eligible_offers.present? && (this_order_construct.request_state.value != Order::ON_COMPLETE)

		get_order_from_builder.adjustments.each{|order_adj|
			adj_build = AdjustmentBuild.new
			adj_build.id = order_adj.id
			adj_build.coupon_code = order_adj.coupon.code
			adj_build.diff_in_sp = order_adj.diff_in_sp
			this_order_construct = get_order_construct_from_builder
			this_order_construct.adjustments ||= []
			this_order_construct.adjustments << adj_build
			set_order_construct_through_builder(this_order_construct)
		}
	end

	def calculate_order_sum_on_null_instance
		# No Action for Null Instance 
		return 
	end
	
	def calculate_order_sum_on_order_instance
		# The final update on order price  - def calculate_price @ Order.rb // instance method
		this_order_construct = get_order_construct_from_builder
		old_total = this_order_construct.total_price
		old_fp = this_order_construct.final_price
		this_order = get_order_from_builder
		updated_price = this_order.calculate_price 
		this_order.update_attributes(:total_price => updated_price[:total],:final_price => updated_price[:final])
		this_order_construct.total_price = updated_price[:total]
		this_order_construct.final_price = updated_price[:final]			
		if !(old_total == this_order_construct.total_price && old_fp == this_order_construct.final_price)
			this_order_construct.errors ||= []
			this_order_construct.errors << OrderError.new("Order value changed","Please verify and try again!!")
		end
		set_order_construct_through_builder(this_order_construct)

	end
	
	def with_bill_data_on_null_instance
		# No Action for Null Instance 
		return 
	end

	def with_bill_data_on_order_instance
		# Complete order and generate bill - def complete_and_create_bill @ Order.rb // instance method
		this_order_construct = get_order_construct_from_builder
		return unless (this_order_construct.request_state.value == Order::ON_COMPLETE)
		unless this_order_construct.errors.present?  
			this_order = get_order_from_builder
			result = get_order_from_builder.complete_and_create_bill
			this_order.save
			if result.is_a? OrderBill
				order_bill = result
				cart_html = ActionController::Base.new.render_to_string(:template => 'cart/cart',:locals => {:cart_data => get_order_construct_from_builder, :final_complete => true})
				order_bill.bill_content = cart_html
				order_bill.save
				bill_build = BillBuild.new
				bill_build.id = order_bill.id
				bill_build.data = order_bill.bill_content
				this_order_construct.bill = bill_build
			elsif result.is_a?(Array) && !result.empty?
				this_order_construct.errors ||= []
				this_order_construct.errors += result
			end		
		end
		set_order_construct_through_builder(this_order_construct)
	end

end