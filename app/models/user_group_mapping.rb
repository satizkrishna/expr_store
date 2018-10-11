class UserGroupMapping < ApplicationRecord
	#Attributes:
	# user_id, group_id
	belongs_to :user
	belongs_to :user_group
end
