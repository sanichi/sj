class GamesController < ApplicationController
  authorize_resource
  before_action :find_game, only: [:destroy, :show, :join, :leave, :play]

  def waiting
    @games = Game.where(state: Game::WAITING)
  end

  def new
    @game = Game.new
  end

  def create
    @game = Game.new resource_params
    @game.user = current_user
    if @game.save
      redirect_to waiting_games_path
    else
      render :new
    end
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

  def leave
    if @game.can_be_left_by?(current_user)
      @game.players.each { |p| p.destroy if p.user == current_user }
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

  def resource_params
    params.require(:game).permit(:participants, :upto)
  end
end
