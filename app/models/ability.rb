class Ability
  include CanCan::Ability

  def initialize(user)
    if user.admin?
      can(:manage, :all)
      return
    end

    unless user.guest?
      can [:play, :create, :waiting], Game
      can :updates, :message
    end
  end
end
