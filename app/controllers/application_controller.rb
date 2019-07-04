class ApplicationController < ActionController::Base
  protect_from_forgery width: :exception
  include SessionsHelper
  # MR see later before_action :logged_in_user
  # MR see later skip_before_action :logged_in_user, only: [:new, :create, :home, :about]
end
