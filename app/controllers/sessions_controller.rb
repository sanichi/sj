class SessionsController < ApplicationController
  def create
    user = User.find_by(handle: params[:handle])
    user = user&.authenticate(params[:password]) unless current_user.admin?
    if user
      session[:user_id] = user.id
      redirect_to play_path
    else
      flash.now[:alert] = t("session.invalid")
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
end
