class Role < ApplicationRecord
	#Attributes:
	# name

	has_and_belongs_to_many :users, :join_table=> :user_role_mappings
end
