class Coupon < ApplicationRecord
	#Attributes:
	# name, starts_at, expires_at, auto_apply, piggy_back

	has_many :coupon_rules
	has_many :coupon_adjustments

	def is_auto_apply?
		(auto_apply || false)
	end

	def is_piggy_back?
		(piggy_back || false)
	end

	def eligible? order
		# returns boolean
		coupon_rules.map{|rule|
			rule.eligible? order
		}.all?
	end

	def get_adjustment_against(order, offer)
		# returns offer
		offer.diff_price = coupon_adjustments.map { |adj|
			adj.get_diff_for_order(order)
		}.reduce(0,:+)
		offer
	end

	def create_adjustment_for(order,offer)
		coupon_adjustments.each { |adj|  
			adj.create_adjustments_for_order(order,offer)
		}
	end

	def self.for_eligible_offers(applied,options)
		active_offers = active_coupons.map { |coupon| 
			[coupon.code,{:auto_apply => coupon.auto_apply, :piggy_back => coupon.piggy_back, :user_applied => false}]
		}.to_h
		if options[:change_offer].present?
			if options[:change_offer].is_a? OrderUtil::RemoveCoupon
				applied.delete_if { |offer|  options[:change_offer].code == offer.code }
			elsif options[:change_offer].is_a? OrderUtil::AddCoupon
				if active_offers[options[:change_offer].code].present?
					active_offers[options[:change_offer].code][:user_applied] = true
				else
					coupon = self.where(:code => options[:change_offer].code).first
					active_offers[options[:change_offer].code] = {:auto_apply => coupon.auto_apply, :piggy_back => coupon.piggy_back, :user_applied => true} if coupon.present?
				end
			end
		end
		applied.each{|offer|
			coupon = self.where(:code => offer.code).first
			next unless coupon.present?
			unless active_offers[coupon.code].present?
				active_offers[offer.code] = {:auto_apply => coupon.auto_apply, :piggy_back => coupon.piggy_back, :user_applied => true}
			end
		}
		active_offers.map { |code,offer|  OrderUtil::EligibleOffer.new(code,offer[:user_applied],offer[:piggy_back],offer[:auto_apply]) }
	end

	private

	def self.active_coupons
		Coupon.where("now() between starts_at and expires_at and max_usage_limit < usage_count")
	end
end
