class PasswordResetsController < ApplicationController
  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]
  before_action :load_user, only: :create

  def new; end

  def edit; end

  def create
    if !@user.activated
      flash[:warning] = t "account_not_activated"
      redirect_to root_url
    else
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t "reset_instruct"
      redirect_to root_url
    end
  end

  def get_user
    @user = User.find_by email: params[:email]
  end

  def valid_user
    return if (@user && @user.activated && @user.authenticated?(:reset, params[:id]))
    redirect_to root_url
  end

  def update
    if user_params[:password].empty?
      flash.now[:error] = t "please_input_password"
      render :edit
    elsif @user.update_attributes user_params
      flash[:success] = t "successfully_update_password"
      redirect_to @user
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def check_expiration
     return unless @user.password_reset_expired?

     flash[:danger] = t "password_reset_has_expired"
     redirect_to new_password_reset_url
  end

  def load_user
    @user = User.find_by email: params[:password_reset][:email].downcase
    return if @user

    flash[:warning] = "not found"
    redirect_to root_url
  end
end
