class SessionsController < ApplicationController
  def create
    user = User.find_by(handle: params[:handle])
    user = user&.authenticate(params[:password]) unless current_user.admin?
    if user
      session[:user_id] = user.id
      redirect_to waiting_games_path
    else
      flash.now[:alert] = t("session.invalid")
      report params[:handle]
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end

  def new
    redirect_to waiting_games_path unless current_user.guest?
  end

  private

  def report(handle)
    handle = 'NONE' if handle.blank?
    ip = request.env['action_dispatch.remote_ip'] || request.env['REMOTE_ADDR']
    logger.error("Failed login attempt for '#{handle}' from #{ip}")
  end
end
