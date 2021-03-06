class SessionsController < ApplicationController
  before_action :load_user, only: :create

  def new; end

  def create
    if @user.try(:authenticate, params[:session][:password])
      acctivation
    else
      flash.now[:danger] = t "sessions.new.invalid_email_password_combination"
      render :new
    end
  end

  def destroy
    log_out
    redirect_to root_path
  end

  private

  def load_user
    @user = User.find_by email: params[:session][:email].downcase
    return if @user

    flash[:danger] = t "error_find_user"
    redirect_to root_path
  end

  def acctivation
    if @user.activated
      log_in @user
      params[:session][:remember_me] == "1" ? remember(@user) : forget(@user)
      redirect_back_or @user
    else
      flash[:warning] = t "account_not_activated"
      redirect_to root_path
    end
  end
end
