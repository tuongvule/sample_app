class UsersController < ApplicationController
  before_action :correct_user, only: [:edit, :update]
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  def show
    @user = User.find_by id: params[:id]
    flash[:success] = t "welcome_to_the_sample_app"
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t "please_check_email"
      redirect_to root_url
    else
      render :new
    end
  end

  def edit
    @user = User.find_by(id: params[:id])
  end

  def update
    @user = User.find_by(id: params[:id])
    if @user.update(user_params)
      flash[:success] = t "profile_updated"
      redirect_to @user
    else
      render "edit"
    end
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t "please_log_in"
    redirect_to login_url
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  def destroy
    @user = User.find_by(id: params[:id])
    if @user&.destroy
      flash[:success] = t "user_deleted"
    else
      flash[:danger] = t "delete_fail"
    end
    redirect_to users_url
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password,
                                 :password_confirmation
  end

  # Confirms the correct user.
  def correct_user
    @user = User.find_by(id: params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end
end
