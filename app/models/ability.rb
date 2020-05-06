class Ability
  include CanCan::Ability

  def initialize(user)
    if user.admin?
      can(:manage, :all)
      return
    end

    unless user.guest?
      can :play, :page
      can :index, Game
    end
  end
end
