class CartController < ApplicationController
	# authorize_resource :class => :false
	skip_load_and_authorize_resource
	
	include OrderHelper
	
	def add_to_cart
		authorize! :a_to_c, :cart
		sku = params[:sku]
		quantity = params[:quantity] || 1
		@cart_data = add_sku_to_cart(sku,quantity)
		respond_to do |format|
			format.json{
				render :json => {:success => @cart_data.errors.present?}
			}
		end
	end

	def remove_from_cart
		authorize! :r_fm_c, :cart
		sku = params[:sku]
		quantity = params[:quantity] || 1
		@cart_data = remove_sku_from_cart(sku,quantity)
		# cart_html = ActionController::Base.new.render_to_string(:template => 'cart/cart',:locals => {:cart_data => @cart_data})
		respond_to do |format|
			format.json{
				render :json => {:success => @cart_data.errors.present?}
			}
		end
	end

	def cart
		authorize! :get, :cart
		@cart_data = get_cart_data
	end

	def apply_coupon
		authorize! :apply_coupon, :cart
		coupon_code = params[:coupon]
		@cart_data = apply_coupon_code(coupon_code)
		# cart_html = ActionController::Base.new.render_to_string(:template => 'cart/cart',:locals => {:cart_data => @cart_data})
		respond_to do |format|
			format.json{
				render :json => {:success => @cart_data.errors.present?}
			}
		end
	end

	def remove_coupon
		authorize! :remove_coupon, :cart
		coupon_code = params[:coupon]
		@cart_data = remove_coupon_code(coupon_code)
		# cart_html = ActionController::Base.new.render_to_string(:template => 'cart/cart',:locals => {:cart_data => @cart_data})
		respond_to do |format|
			format.json{
				render :json => {:success => @cart_data.errors.present?}
			}
		end
	end

	def complete_purchase
		authorize! :complete, :cart
		@cart_data = complete_purchase_now
		if @cart_data.bill.present?
			flash[:success] = "Order Placed successfully!!"
			flash[:success] = "Please check the downloaded invoice!!"
			pdf = WickedPdf.new.pdf_from_string(@cart_data.bill.data)
			send_data(pdf, 
         		:filename    => "invoice.pdf", 
         		:disposition => 'attachment')
			# redirect_back(fallback_location: root)
		else
			flash[:error] = @cart_data.errors.first.message
			redirect_back(fallback_location: '/cart/cart')
		end
	end	

end
