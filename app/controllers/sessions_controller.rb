class SessionsController < ApplicationController
  def new; end

  def load_user
    @user = User.find_by email: params[:session][:email].downcase
  end

  def create
    load_user
    if @user.try(:authenticate, params[:session][:password])
      log_in @user
      params[:session][:remember_me] == "1" ? remember(@user) : forget(@user)
      redirect_back_or @user
    else
      flash.now[:danger] = (t "sessions.new.invalid_email_password_combination")
      render :new
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end
end
