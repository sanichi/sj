class UsersController < ApplicationController
  load_and_authorize_resource

  def index
    @users = User.paginate(@users, params, users_path, remote: true)
  end

  def create
    if @user.save
      redirect_to @user
    else
      failure @user
      render :new
    end
  end

  def update
    if @user.update(resource_params)
      redirect_to @user
    else
      failure @user
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to users_path
  end

  def scores
    @players = Player.paginate(@user.players.finished, params, scores_user_path, remote: true)
  end

  private

  def resource_params
    params.require(:user).permit(:handle, :password, :first_name, :last_name)
  end
end
