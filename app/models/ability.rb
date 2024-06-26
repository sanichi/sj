class Ability
  include CanCan::Ability

  def initialize(user)
    if user.admin?
      can(:manage, :all)
      return
    end

    unless user.guest?
      can [:waiting, :refresh, :create, :join, :play], Game
      can :destroy, Game, user_id: user.id, state: Game::WAITING
      can [:push, :pull], :message
      can :scores, User
    end
  end
end
