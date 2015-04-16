class HomeController < ApplicationController

  layout 'angular'

  def index
    if current_user && user_signed_in?
      render 'index'
    else
      redirect_to new_user_session_path
    end
  end
end
