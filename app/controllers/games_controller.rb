class GamesController < ApplicationController
  authorize_resource
  before_action :find_game, only: [:destroy, :show, :join, :leave, :play]

  def waiting
    @games = Game.where.not(state: Game::FINISHED)
  end

  def index
    @games = Game.search(params, games_path, remote: true, per_page: 10)
  end

  def new
    @game = Game.new(debug: current_user.admin?)
  end

  def create
    @game = Game.new resource_params
    @game.user = current_user
    if @game.save
      @game.players.create(user: current_user)
      @game.start
      redirect_to waiting_games_path
    else
      render :new
    end
  end

  def destroy
    @game.destroy if @game
    redirect_to waiting_games_path
  end

  def join
    if @game && @game.can_be_joined_by?(current_user)
      @game.players.create(user: current_user)
    end
    redirect_to waiting_games_path
  end

  def leave
    if @game && @game.can_be_left_by?(current_user)
      @game.players.each { |p| p.destroy if p.user == current_user }
    end
    redirect_to waiting_games_path
  end

  def play
    if @game && (@player = @game.can_be_played_by(current_user))
      @game.update_column(:state, Game::STARTED) if @game.state == Game::WAITING
      @game.deal(@player.id)
    else
      redirect_to waiting_games_path
    end
  end

  private

  def find_game
    @game = Game.find_by(id: params[:id])
  end

  def resource_params
    permitted = [:participants, :upto]
    permitted.push :debug if current_user.admin?
    params.require(:game).permit(*permitted)
  end
end
