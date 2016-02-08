class AppUsersController < ApplicationController
	def index
		@app_users = AppUser.all
	end

	def new
		@app_user = AppUser.new
	end
	def edit
		@app_user = AppUser.find(params[:id])
	end
	def create
		@app_user = AppUser.new(app_user_params)
		respond_to do |format|
			if @app_user.save
				format.html { redirect_to app_users_path, :notice => 'Successfully created.' }
				format.xml { render :xml => app_user, :status => :created, :app_user => @app_user }
				format.html { render :action => "new" }
				format.xml { render :xml => app_user.errors, :status => :unprocessable_entity }
			end
		end
	end

	def update
		@app_user = AppUser.find(params[:id])
    	respond_to do |format|
      		if @app_user.update_attributes(app_user_params)
        		format.html { redirect_to app_users_path, notice: 'You have successfully updated a user.' }
        		format.xml  { render :xml => @app_user, :status => :created, :user => @app_user }
      		else
        		format.html { render :edit }
        		format.json { render json: @app_user.errors, status: :unprocessable_entity }
      		end
    	end
  	end
  	def destroy
    	@app_user = AppUser.find(params[:id])
    	respond_to do |format|
      		if @app_user.destroy
        		format.html { redirect_to app_users_path, :notice => 'You have successfully removed a user' }
        		format.xml  { render :xml => @app_user, :status => :created, :app_user => @app_user }
      		end
    	end
   end

	private
	def app_user_params
		params.require(:app_user).permit(:app_user_name, :avatar, :email, :mobile_no, :password, :unhashed_password, :device_token, :device_flag)
	end
end		