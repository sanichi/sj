class GamesController < ApplicationController
  authorize_resource
  before_action :find_game, only: [:delete, :play]

  def index
    @games = Game.all
  end

  def destroy
    @game.destroy
    redirect_to games_path
  end

  def play
    @player = @game.players.find_by(user: current_user) || Player.create(game: @game, user: current_user)
  end

  private

  def find_game
    @game = Game.find(params[:id])
  end
end
