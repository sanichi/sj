class GamesController < ApplicationController
  authorize_resource
  before_action :find_game, only: [:destroy, :show, :play]

  def index
    @games = Game.all
  end

  def new
    Player.create(game: Game.new, user: current_user)
    redirect_to games_path
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
