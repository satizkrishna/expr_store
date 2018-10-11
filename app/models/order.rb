class Order < ApplicationRecord
	# TODO: Create OrderException class and throw Exceptions to provide detailed failure responses.
	include OrderUtil
	#Attributes:
	# order_number, total_price, final_price, state
	belongs_to :user
	has_many :line_items, :dependent =>  :destroy
	has_many :adjustments, :class_name => 'OrderAdjustment', :dependent => :destroy 
	has_one :order_bill
	has_many :order_adjustments, :as => :order_entity

	after_create :set_order_number 

	def set_order_number
		self.update_attribute(:number , Date.today.to_s.gsub('-','') + ('%09d'% id))
	end

	def add_line_item(sku,qty)
		errors = []
		variant = Variant.find_by(:sku => sku)
		if variant.available?
			if variant.quantity_available?(qty)
				li = line_items.where(:variant_id => variant.id).first
				li = line_items.new(variant_id: variant.id,mrp: variant.price.mrp,sp: variant.price.sp) unless li.present?
				li.quantity += qty
				li.mrp *= li.quantity
				li.sp *= li.quantity
				li.save
			else
				errors << OrderError.new("Failed Add_To_Cart","Quantity not available")
			end
		else	
			errors <<  OrderError.new("Failed Add_To_Cart","Item not available")
		end
		errors
	end
	
	def remove_line_item(sku,qty)
		variant = Variant.find_by(:sku => sku)
		li = line_items.where(:variant_id => variant.id).first
		if li.present?
			li.quantity -= qty
			li.mrp = variant.price.mrp * li.quantity
			li.sp = variant.price.sp * li.quantity
			li.save
		else
			return [OrderError.new("Failed Remove_From_Cart","Item does not belong to cart")]
		end
		return []
	end

	def remove_adjustment_for(code)
		adjustments.each{|adj|
			adj.delete if adj.coupon.code == code
		}
	end

	def create_adjustment_for(offer)
		coupon = Coupon.find_by(:code => offer.code)
		coupon.create_adjustment_for(self,offer) # def 
	end

	def calculate_price
		line_items_total_sum = line_items.pluck(:mrp).reduce(0,:+)
		puts "line_items_total_sum #{line_items_total_sum}"
		line_items_final_sum = line_items.pluck(:sp).reduce(0,:+)
		puts "line_items_final_sum #{line_items_final_sum}"
		adjustments_on_order = order_adjustments.pluck(:diff_in_sp).reduce(0,:+)
		puts "adjustments_on_order #{adjustments_on_order}"
		total_price = line_items_total_sum
		final_price = line_items_final_sum + adjustments_on_order
		return {:total => total_price,:final => final_price}
	end

	def get_applied_offers
		adjustments.map { |adj|  EligibleOffer.new(adj.coupon.code,adj.user_applied) }.uniq
	end

	def get_eligible_offers(options)
		applied_offers = get_applied_offers
		eligible_offers = []
		coupons_to_check = Coupon.for_eligible_offers(applied_offers,options)
		best_auto_select = nil
		coupons_to_check.each{|offer|
			coupon = Coupon.find_by(:code => offer.code)
			if coupon.present? && coupon.eligible?(self) # def // just checks rules
				offer = coupon.get_adjustment_against(self,offer)  # def // gets adjusment diff price only
				eligible_offers << offer if offer.piggy_back && offer.auto_apply
				eligible_offers << offer if offer.piggy_back && offer.user_applied?
				best_auto_select = offer if (offer.user_applied? || offer.auto_apply) && (best_auto_select.nil? || (best_auto_select.diff_price < adjustment.diff_price))
			end
		}
		eligible_offers << best_auto_select if best_auto_select.present?
		eligible_offers		
	end

	def complete_and_create_bill
		errors = []
		errors += verify_line_items
		errors << OrderError.new("Failed Complete_Cart","Some Coupon/s are changed.") unless coupons_available?
		if errors.empty?
			create_and_get_bill
		else
			errors
		end
	end

	private

	def verify_line_items
		errors = []
		line_items.each { |li|  
			li_var = li.variant
			errors << OrderError.new("Failed Complete_Cart","Some item/s are out of stock!. Please try again.") unless li_var.available?
				unless li_var.quantity_available?(li.quantity)
					begin
						li.auto_adjust_quantity
					rescue "LineItemRemoved"
						errors << OrderError.new("Failed Complete_Cart","Some item/s are not available. Please try again.")
					rescue "LineItemAdjusted"
						errors << OrderError.new("Failed Complete_Cart","Some item/s quantity has been changed due to unavailability!. Please try again.")
					end
				end
		}
		errors
	end

	def coupons_available?
		adjustments.map { |adj|  adj.coupon.eligible?(self) }.all? # def
	end

	def create_and_get_bill
		order_bill = OrderBill.create()
		self.update_attribute(:state , Order::COMPLETE)
		order_bill
	end


end
