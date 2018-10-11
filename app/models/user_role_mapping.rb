class UserRoleMapping < ApplicationRecord
	#Attributes:
	# user_id, role_id
	belongs_to :user
	belongs_to :role
end
