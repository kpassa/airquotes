class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, :login
    can :read, :logout

    if user
      can :manage, Estimate, :user_id => user.id
    end

  end
end
