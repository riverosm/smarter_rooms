class ApplicationController < ActionController::Base
  protect_from_forgery width: :exception
  include SessionsHelper
  include ApplicationHelper
  before_action :logged_in_user
  skip_before_action :logged_in_user, only: [:new, :create, :home, :about]

  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found

  def record_not_found
    flash[:danger] = 'The record was not found.'
    redirect_to root_url
  end

  def verify_if_admin_and_redirect_with_error_message_if_not
    unless logged_in? && current_user.is_admin?
      flash[:danger] = 'You are not authorized to perform that action'
      redirect_to root_url
    end
  end
end
