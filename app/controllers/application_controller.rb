class ApplicationController < ActionController::Base
  protect_from_forgery width: :exception
  include SessionsHelper
  before_action :logged_in_user
  skip_before_action :logged_in_user, only: [:new, :create, :home, :about]

  def verify_if_admin_and_redirect_with_error_message_if_not
    unless current_user.is_admin?
      flash[:danger] = 'You are not authorized to perform that action'
      redirect_to root_url
    end
  end
end
