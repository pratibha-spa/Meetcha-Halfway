class AdminUsersController < ApplicationController
  skip_before_filter :authenticate_admin_user!, :only => [:reset_password, :set_reset_password]
  #before_action :user_params, :only => [:create]
  #load_and_authorize_resource

  def index
    @admin_users = AdminUser.all
  end
end  