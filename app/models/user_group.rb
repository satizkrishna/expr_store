class UserGroup < ApplicationRecord
	#Attributes:
	# name

	has_and_belongs_to_many :users, :join_table=> :user_group_mappings

	scope :users, lambda{}
end
