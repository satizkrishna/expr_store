class OrderBuilder
	# TODO: Create OrderException class and throw Exceptions to provide detailed failure responses.
	include OrderUtil

	public

	def build_and_get
		with_order_data
		with_line_items_data
		find_best_offers
		with_order_offers
		calculate_order_sum
		with_bill_data
		get_order_construct
	end

	def get_order_construct
		Rails.logger.debug "ORDER BUILDER get_order_construct :: #{@order.inspect}"
		@order
	end

	def set_order_construct(order_construct)
		@order = order_construct
	end

	def get_order
		@this_order
	end

	def get_options
		@options
	end

	def initialize(this_order = nil,options = {:request => Order::CART})
		Rails.logger.debug "ORDER BUILDER this_order :: #{this_order}, options :: #{options}"
		@this_instance = this_order
		@options = options
		@this_instance = OrderPayloadInstanceBuilder.build(@this_instance)
		@this_order = @this_instance.instance if @this_instance.is_a? OrderInstance
		@payld_gen = OrderPayloadGenerator.new(self)
		@order = OrderBuild.new
		@order.request_state = OrderState.new(options[:request] || Order::CART)
	end

	private

	def find_best_offers
		@payld_gen.do_op(:find_best_offers,@this_instance)
		self
	end

	def calculate_order_sum
		@payld_gen.do_op(:calculate_order_sum,@this_instance)
		self
	end

	def with_order_data
		@payld_gen.do_op(:with_order_data,@this_instance)
		self
	end

	def with_line_items_data
		@payld_gen.do_op(:with_line_items_data,@this_instance)
		self
	end

	def with_order_sum
		@payld_gen.do_op(:with_order_sum,@this_instance)
		self
	end

	def with_order_offers
		@payld_gen.do_op(:with_order_offers,@this_instance)
		self
	end

	def with_bill_data
		@payld_gen.do_op(:with_bill_data,@this_instance)
		self
	end

end