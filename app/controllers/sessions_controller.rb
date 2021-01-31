class SessionsController < ApplicationController
  before_action :load_user, only: :create
  def new; end

  def create
    if @user.try(:authenticate, params[:session][:password])
      acctivation
    else
      flash.now[:danger] = (t "sessions.new.invalid_email_password_combination")
      render :new
    end
  end

  def destroy
    log_out
    redirect_to root_path
  end

  private

  def acctivation
    if @user.activated
      log_in @user
      params[:session][:remember_me] == "1" ? remember(@user) : forget(@user)
      redirect_back_or @user
    else
      message = "Account not activated.
       Check your email for the activation link."
      flash[:warning] = message
      redirect_to root_path
    end
  end

  def load_user
    @user = User.find_by email: params[:session][:email].downcase
  end
end
