class User < ApplicationRecord
	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
	devise :database_authenticatable, :registerable,
		:recoverable, :rememberable, :validatable,
		:trackable, :omniauthable
	#Attributes:
	# email, password

	has_and_belongs_to_many :roles, :join_table=>:user_role_mappings
	has_and_belongs_to_many :user_groups, :join_table=>:user_group_mappings
	has_many :orders

	validates :email, presence: true, length: { minimum: 10 }
	# validates :name, presence: true, length: { minimum: 5 }

	after_create :create_user_role

	ROLES = %w[user admin]

	def admin?
		self.roles.pluck(:name).include? ROLES[1]
	end

	def customer?
		self.roles.pluck(:name).include? ROLES[0]
	end

	def groups
		self.user_groups
	end

	def current_order
		cart_order = orders.where(:state => Order::CART).order(updated_at: :desc).first
		cart_order = orders.create() unless cart_order.present?
		cart_order
	end

	private

	def create_user_role
		self.roles << Role.find_or_create_by(:name => ROLES[0])
	end

end
