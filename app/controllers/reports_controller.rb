require 'chartkick'
class ReportsController < ApplicationController
	# authorize_resource :class => :false
	skip_load_and_authorize_resource

	def master_report
		authorize! :master, :report
		
		last24hr_orders = Order.where("state = ? and created_at > ?",Order::COMPLETE,Time.now - 24.hour)
		@gross_total = last24hr_orders.pluck(:final_price).reduce(0,:+)
		@total_orders = last24hr_orders.count
		min_mapping = ActiveRecord::Base.connection.select_all("SELECT FROM_UNIXTIME(FLOOR(UNIX_TIMESTAMP(created_at)/300)*300) x , sum(final_price) summ FROM orders where state = 2 GROUP BY x;")
		@w = {}
		min_mapping.rows.each{|k,v| @w[k] = v}
		
	end
end
