class StaticPagesController < ApplicationController
  def home
    if !logged_in?
      redirect_to login_path
    end
  end

  def about
  end
end