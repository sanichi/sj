class SessionsController < ApplicationController
  def create
    user = User.find_by(handle: params[:handle])
    user = user&.authenticate(params[:password]) unless current_user.admin?
    if user
      session[:user_id] = user.id
      redirect_to play_path
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
    redirect_to play_path unless current_user.guest?
  end

  private

  def report(handle)
    handle = 'NONE' if handle.blank?
    ip = request.env['action_dispatch.remote_ip'] || request.env['REMOTE_ADDR']
    time = Time.now.utc.iso8601
    logger.error("Failed login attempt for '#{handle}' from #{ip} at #{time}")
  end
end
