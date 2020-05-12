class Ability
  include CanCan::Ability

  def initialize(user)
    if user.admin?
      can(:manage, :all)
      return
    end

    unless user.guest?
      can [:waiting, :create, :join, :leave, :play], Game
      can :destroy, Game, user_id: user.id, state: Game::WAITING
      can [:push, :pull], :message
    end
  end
end
