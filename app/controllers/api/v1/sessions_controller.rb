class Api::V1::SessionsController < Devise::SessionsController
  skip_before_filter :verify_authenticity_token, :except => [:create]
                     #:if => Proc.new { |c| c.request.format == 'application/json' }
  respond_to :json

  def create
    @app_user = AppUser.find_by_mobile_no(params[:mobile_no])
    if @app_user.present?
      if params[:device_token].present? && params[:device_flag].present?
        @app_user.device_flag = params[:device_flag]
        @app_user.device_token = params[:device_token]
        @app_user.save
      end
      if @app_user.unhashed_password == params[:password]
        render :status => 200,
               :json => { :success => true,
                          :info => "Logged in.",
                          :data => @app_user.as_json(:except => [:created_at, :updated_at, :avatar, :device_token, :device_flag, :password, :unhashed_password])
                        }
      else
          render :status => 401,
               :json => { :success => false,
                          :info => "Sign In Failure.",
                          :data => {} 
                        }
      end            
    else
      render :status => 401,
             :json => { :success => false }
    end            
  end

  def destroy
    warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#failure")
    current_user.update_column(nil)
    render :status => 200,
           :json => { :success => true,
                      :info => "Logged out",
                      :data => {} 
                    }
  end

  def failure
    render :status => 401,
           :json => { :success => false,
                      :info => "Login Failed",
                      :data => {} }
  end

  private
  def app_user_params
    params.permit(:name, :email, :mobile_no, :password, :avatar, :device_token, :device_flag)
  end

  #def create
  #  app_user = AppUser.authenticate(params[:email], params[:password])
  #  if app_user
  #    session[:app_user_id] = app_user.id
  #    render :status => 200,
  #         :json => { :success => true,
  #                    :info => "Logged in",
  #                    :data => {} 
  #                  }
  #  else
  #    render :status => 401,
  #         :json => { :success => false,
  #                    :info => "Login Failed",
  #                    :data => {} 
  #                  }
  #  end
  #end

end