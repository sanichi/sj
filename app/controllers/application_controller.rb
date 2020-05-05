class ApplicationController < ActionController::Base
  helper_method :current_user

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html { redirect_to current_user.guest? ? root_path : play_path, alert: exception.message }
      format.json { head :forbidden, content_type: "text/html" }
      format.js   { head :forbidden, content_type: "text/html" }
    end
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) || Guest.new
  end

  def current_player
    return if current_user.guest?
    game = Game.last || Game.create
    game.players.find_by(user: current_user) || Player.create(game: game, user: current_user)
  end

  def failure(object)
    flash.now[:alert] = object.errors.full_messages.join(", ")
  end
end
