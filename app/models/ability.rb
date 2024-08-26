class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.admin?
      can :manage, :all
    elsif user.staff?
      can :update, Product
      can :manage, User, id: user.id
      can :read, Product
    else
      can :read, Product
      can :update, Order, status: 'in_progress'
      can :manage, User, id: user.id
    end
  end
end
