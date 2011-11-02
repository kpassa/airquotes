class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user

    if user.admin?
      can :manage, :all
    else
      can :manage, Estimate, :user_id => user.id
    end

  end
end
