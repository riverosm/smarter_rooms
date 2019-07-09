class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)

    if user && user.authenticate(params[:session][:password])
      log_in user
      # MR - Change later to rooms_url
      redirect_to root_url
    else
      flash.now[:danger] = 'Invalid email/password combination'
      redirect_to login_url
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end

end