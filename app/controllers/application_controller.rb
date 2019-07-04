class ApplicationController < ActionController::Base
  protect_from_forgery width: :exception
  include SessionsHelper
  before_action :logged_in_user
  skip_before_action :logged_in_user, only: [:new, :create, :home, :about]
end
