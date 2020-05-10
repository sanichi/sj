class GamesController < ApplicationController
  authorize_resource
  before_action :find_game, only: [:destroy, :show, :join, :play]

  def waiting
    @games = Game.where(state: Game::INIT)
  end

  def new
    game = Game.create(user: current_user)
    game.messages.create(pack: game.card, discard: game.card)
    redirect_to waiting_games_path
  end

  def destroy
    @game.destroy
    redirect_to waiting_games_path
  end

  def join
    if @game.can_be_joined_by?(current_user)
      player = @game.players.create(user: current_user)
      @game.messages.create(hand: @game.cards(12), player_id: player.id)
    end
    redirect_to waiting_games_path
  end

  def play
    if @game.can_be_played_by?(current_user)
      @player = @game.players.find_by(user: current_user)
    else
      redirect_to waiting_games_path
    end
  end

  private

  def find_game
    @game = Game.find(params[:id])
  end
end
