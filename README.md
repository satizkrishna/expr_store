# README

This is an Experimental project, represents a store. The store includes,
	> User
	> Item
	> Order

There are two kinds of users,
	> Customer - surf inventory, do cart transacations, receive bill after purchase
	> Admin - Can do all CRUD operations against all models. Due to time constraint Admin Dashboard to manage resources was ignored. Additionally, these users will have access to the report dashboard to see the overall transactions.

Item, comprises of,
	> Variant - size variants or any other kind of variants with Price and Asset(images).
	> Category - Category of an Item
	> Property - Properties, an Item can have.

Order, comprises of,
	> LineItem - individual item sku's in the cart grouped together
	> Adjustment - changes to order value, based on available Coupon/s.

Coupon, include,
	> Rule/s - basic checks on Order, Item and User to eligible criteria.
	> Adjustment - Operations to be run on top of the order, (Order & Item level)


Apart from these, the project includes,
	> OrderUtil
		- OrderBuilder & OrderPayloadGenerator - basic operations on orders are done here, and the Order construct for external use will be provided. This also helps in building the CouponRule, means, the Coupon system should not worried on changes happening at the Order level in future.
	> PageHelper
		- Provides feed data


STEPS TO RUN THE PROJECT:
	1. bundle install
	2. rake db:create (make sure MySQL is running)
	3. rake db:migrate
	4. rake importer:priliminary_import (Adds basic data to make sure the application is running)

FLOWS:
	Customer:
		Login > Surf Category > Surf Products > Add to cart
		Cart > Remove Items > Add Coupon > Remove Coupon > Complete Order > Get Bill

	Admin:
		All Customer Flows, and,
		ReportDashboard > Check Today's Transaction.




