class HomeController < ApplicationController
	# authorize_resource :class => :false
	skip_load_and_authorize_resource
	
	include PageHelper
	
	PAGE_LIMIT = 12

	def index
		authorize! :index, :home
		@store_data = {}
		@store_data[:categories] = get_categories_data
		# @store_data[:categories] = [{:id => 1, :name => "cat.name1", :slug => "cat.slug", :description => "cat.description"},{:id => 1, :name => "cat.name2", :slug => "cat.slug", :description => "cat.description"},{:id => 1, :name => "cat.name3", :slug => "cat.slug", :description => "cat.description"},{:id => 1, :name => "cat.name4", :slug => "cat.slug", :description => "cat.description"},{:id => 1, :name => "cat.name5", :slug => "cat.slug", :description => "cat.description"}]
		@store_data[:alert_no_categories] = @store_data[:categories].empty?
	end

	def category
		authorize! :category, :home
		category_slug = params[:slug]
		category = Category.find_by_slug(category_slug)
		params[:page] ||= 0
		page_lim = PAGE_LIMIT
		active_items = Item.joins(:categories).active.in_stock.with_page_info.recent_first.where("categories.id = #{category.id}").limit(page_lim).offset(params[:page]*page_lim)
		@page_info = get_page_info_from(active_items) 
	end

end
