class GamesController < ApplicationController
  authorize_resource
  before_action :find_game, only: [:destroy, :show, :join]

  def waiting
    @games = Game.where(state: Game::INIT)
  end

  def new
    Game.create(user: current_user)
    redirect_to waiting_games_path
  end

  def destroy
    @game.destroy
    redirect_to waiting_games_path
  end

  def join
    if @game.can_be_joined_by?(current_user)
      @game.players << Player.create(user: current_user)
    end
    redirect_to waiting_games_path
  end

  private

  def find_game
    @game = Game.find(params[:id])
  end
end
