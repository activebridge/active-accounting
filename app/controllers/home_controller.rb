class HomeController < ApplicationController
  before_filter :set_gon_variables

  layout 'angular'

  def index
    if current_user && user_signed_in?
      render 'index'
    else
      redirect_to new_user_session_path
    end
  end

  private

  def set_gon_variables
    gon.article_types = Article::TYPES.constants
    gon.counterparty_types = Counterparty::TYPES.constants
    gon.counterparty_display_types = Counterparty::TYPES::DISPLAY_TYPES
  end
end
