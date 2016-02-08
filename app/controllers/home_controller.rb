class HomeController < ApplicationController
  #before_filter :authenticate_user!, :except => [:index]

  def index
    redirect_to new_admin_user_session_path if !admin_user_signed_in? 
  end

end