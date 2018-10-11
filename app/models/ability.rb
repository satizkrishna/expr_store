class Ability
  include CanCan::Ability

  def initialize(user)
      user ||= User.new # guest user (not logged in)
      
      if user.admin?
        can :manage, :all
      
      elsif user.customer?
        can :index, :home
        can :category, :home
        can :a_to_c, :cart
        can :r_fm_c, :cart
        can :get, :cart
        can :apply_coupon, :cart
        can :remove_coupon, :cart
        can :complete, :cart
      
      end
  end
end
