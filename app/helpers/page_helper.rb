module PageHelper

	module_function

	def get_page_info_from(items)
		page_info = {}
		page_info[:alert_no_items] = items.empty?
		page_info[:items] = []
		items.each{|item|
			item_data = {}
			item_data[:name] = item.name
			item_data[:description] = item.description
			item_data[:slug] = item.slug
			item_data[:variants] = item.variants.map{|variant| {:sku => variant.sku, :display_str => variant.display_str , :image_url => variant.item_asset.image_url, :mrp => variant.price.mrp, :sp => variant.price.sp } }
			page_info[:items] << item_data
		}
		page_info
	end

	def get_categories_data
		Category.all.map{|cat| {:id => cat.id, :name => cat.name, :slug => cat.slug, :description => cat.description} }
	end

end