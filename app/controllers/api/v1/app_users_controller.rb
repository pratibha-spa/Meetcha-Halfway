class Api::V1::AppUsersController < ApplicationController
	skip_before_filter :verify_authenticity_token
	respond_to :json
	def new
		@app_user = AppUser.new
	end

  def update_app_user
    @app_user = AppUser.find_by_mobile_no(params[:mobile_no])
    if @app_user.present?
      if params[:name].present? || params[:email].present? || params[:profile_image].present?
        @app_user.update(app_user_params)
        render :status => 200,
               :json => { :success => true }
      else
        render :status => 400,
               :json => { :success => false }  
      end
    else
        render :status => 400,
               :json => { :success => false }
    end 
  end

  def create
    @app_user = AppUser.find_by_mobile_no(params[:mobile_no])
    if @app_user.present?
      render :status => 400,
             :json => {:success => false}
    else
      @app_user = AppUser.new(app_user_params) 
      @app_user.unhashed_password = params[:password]
      if @app_user.save
        render :status => 200,
               :json => { :success => true, :app_user_id => @app_user.id }
      else
        render :status => 400,
               :json => { :success => false }
      end
    end
  end

	private
	def app_user_params
    params[:avatar] = decode_profile_image(params[:profile_image]) if params[:profile_image].present?
		params.permit(:app_user_name, :email, :mobile_no, :device_flag, :device_token, :password, :unhashed_password, :avatar)
	end

  def decode_profile_image(profile_image)
    # decode the base64
    data = StringIO.new(Base64.decode64(profile_image))

    # assign some attributes for carrierwave processing
    data.class.class_eval { attr_accessor :original_filename, :content_type }
    data.original_filename = "upload.png"
    data.content_type = "image/png"

    # return decoded data
    data
  end

end	