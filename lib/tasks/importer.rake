namespace :importer do
  desc "TODO"
  task priliminary_import: :environment do
  	roles = User::ROLES
  	
  	roles.each{|role|
  		Role.create(:name => role)
  	}
  	users_data = [["aaa@gmail.com","testpass",roles[0]],["bbb@gmail.com","testpass",roles[1]]]
  	
  	users_data.each{|user_a_data|
	  	user_a = User.new
	  	user_a.email = user_a_data[0]
	  	user_a.password = user_a_data[1]
	  	user_a.password_confirmation = user_a_data[1]
	  	user_a.roles << Role.find_by(:name => user_a_data[2])
	  	user_a.save
  	}




	[{:name => "Biscuits",:slug => "biscuits",:description => "Biscuits Biscuits Biscuits"},{:name => "Chocolates",:slug => "chocolates",:description => "Chocolates Chocolates Chocolates"},{:name => "Home Cleaning",:slug => "home",:description => "Home Home Home"},{:name => "Rice & Dhal",:slug => "rice",:description => "Rice Rice Rice"},{:name => "Clothing",:slug => "clothing",:description => "Clothing Clothing Clothing"},{:name => "Furniture",:slug => "furniture",:description => "Furniture Furniture Furniture"},{:name => "Stationary",:slug => "stationary",:description => "Stationary Stationary Stationary"},{:name => "Drinks",:slug => "drinks",:description => "Drinks Drinks Drinks"}].each{|cat|
		Category.create(cat)
	}


	item_data = {:name => "Milk Bikis" , :slug => "mbks" , :description => "resdrfguhijkugjfhtdg", :state => 2, :count_on_hand => 50,
	:variants => [
	{:sku => "MBKS-XAA-S" , :display_str => "S", :count_on_hand => 10, :price => {:mrp => 500, :sp => 400}, :asset => {:image_url => "http://shopitsoon.com/image/cache//Britannia-Milk-Bikis-100g84486/main-800x800.jpg"}},
	{:sku => "MBKS-XAA-R" , :display_str => "R", :count_on_hand => 10, :price => {:mrp => 550, :sp => 450}, :asset => {:image_url => "http://shopitsoon.com/image/cache//Britannia-Milk-Bikis-100g84486/main-800x800.jpg"}},
	{:sku => "MBKS-XAA-L" , :display_str => "L", :count_on_hand => 10, :price => {:mrp => 600, :sp => 500}, :asset => {:image_url => "http://shopitsoon.com/image/cache//Britannia-Milk-Bikis-100g84486/main-800x800.jpg"}},
	{:sku => "MBKS-XAA-XL" , :display_str => "XL", :count_on_hand => 10, :price => {:mrp => 700, :sp => 600}, :asset => {:image_url => "http://shopitsoon.com/image/cache//Britannia-Milk-Bikis-100g84486/main-800x800.jpg"}},
	{:sku => "MBKS-XAA-XS" , :display_str => "XS", :count_on_hand => 10, :price => {:mrp => 400, :sp => 300}, :asset => {:image_url => "http://shopitsoon.com/image/cache//Britannia-Milk-Bikis-100g84486/main-800x800.jpg"}}
	],
	:properties => [
	{:name => "dietary restrictions", :description => "advdjyfgsuDALK", :property_values => [{:name => "pure veg", :description => "not even egg!! phew!!"}]},
	{:name => "ingredient", :description => "advdjyfgsuDALK", :property_values => [{:name => "wheat", :description => "plant"},{:name => "milk", :description => "cow"}]},
	],
	:categories => [
	{:name => "Biscuits", :slug => "biscuits", :description => "Biscuits Biscuits Biscuits"}
	]
	}

	item = Item.create({:name => item_data[:name],:slug => item_data[:slug], :description => item_data[:description], :state => item_data[:state], :count_on_hand => item_data[:count_on_hand]})
	item_data[:variants].each{|vari_data|
		puts vari_data
		vari = item.variants.new({:sku => vari_data[:sku], :display_str => vari_data[:display_str], :count_on_hand => vari_data[:count_on_hand]})
		price_data = vari_data[:price]
		puts price_data
		price = Price.new({:mrp => price_data[:mrp], :sp => price_data[:sp]})
		vari.price = price
		asset_data = vari_data[:asset]
		puts asset_data
		vari.item_asset = ItemAsset.new({:image_url => asset_data[:image_url]})
	}
	item.save
	item_data[:properties].each{|prop_data|
		property = ItemProperty.find_by(:name => prop_data[:name])
		property = ItemProperty.create({:name => prop_data[:name], :description => prop_data[:description]}) unless property.present?
		prop_data[:property_values].each{|pv_data|
			pv = property.item_property_values.new({:name => pv_data[:name], :description => pv_data[:description]})
			item.item_property_values << pv
		}
		property.save
	}
	item_data[:categories].each{|categories_data|
		category = Category.find_by(:name => categories_data[:name])
		category = Category.create(categories_data) unless category.present?
		item.categories << category
	}


	coupon = Coupon.create(:starts_at => Time.now,:expires_at  => Time.now + 10.day, amount: 100.0, max_usage_limit: 100, code: "FLASH")
	coupon.coupon_rules << CouponRule::OrderCouponRule.new(check_column: "order.final_price", operator: 15, expected_value: "1300")
	coupon.coupon_adjustments << CouponAdjustment::FlatPercentAdjustment.new(amount: 10, on_item: false, max_discount: 200)
  end

end
