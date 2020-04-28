class ApplicationController < ActionController::Base
  def current_user
    # @current_user ||= User.find_by(id: session[:user_id]) || Guest.new
    @current_user = User.find(1)
  end

  def failure(object)
    flash.now[:alert] = object.errors.full_messages.join(", ")
  end
end
