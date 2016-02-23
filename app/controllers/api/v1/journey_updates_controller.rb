class Api::V1::JourneyUpdatesController < ApplicationController
	skip_before_filter :verify_authenticity_token
	respond_to :json

	def save_your_current_location
		@meeting_detail = MeetingDetail.find_by_id(params[:meeting_detail_id])
		if @meeting_detail.present? && @meeting_detail.meeting_status == true
			@journey = JourneyUpdate.find_by_meeting_detail_id_and_app_user_id(params[:meeting_detail_id],params[:app_user_id])
			if @journey.present?
				@journey.update(journey_update_params)
        	render :status => 200,
          	     :json => { :success => true }
			else
				if params[:app_user_id] == @meeting_detail.m_request_sender_id
					@meeting_receiver_id = @meeting_detail.m_request_receiver_id
				elsif params[:app_user_id] == @meeting_detail.m_request_receiver_id
					@meeting_receiver_id = @meeting_detail.m_request_sender_id
				end
				@app_user = AppUser.find_by_id(@meeting_receiver_id)
				@journey = JourneyUpdate.new(journey_update_params)
				if @journey.save
					if @app_user.device_flag == "android"
						gcm = GCM.new("AIzaSyC7tEx94lVkuevlmRu2g5CDXQkX7exMyw0")
    				registration_id = ["#{@app_user.device_token}"]
    				gcm.send(registration_id, {data: {message: "#{@app_user.app_user_name} has started journey."}})
    			elsif @app_user.device_flag == "iphone"
						pusher = Grocer.pusher(
        			certificate: "#{Rails.root}/config/certificates/DevPush_Meetcha.pem",      	# required
        			passphrase:  "12345",                       																	# optional
        			gateway:     "gateway.sandbox.push.apple.com",                      				# optional; See note below.
        			port:        2195,                       																		# optional
        			retries:     3                           																		# optional
      			)
      			notification = Grocer::Notification.new(
        			device_token:      "#{@app_user.device_token}",
        			alert:             "#{@app_user.app_user_name} has started journey.",
        			badge:             42
        			#category:          "a category",         																	# optional; used for custom notification actions
        			#sound:             "siren.aiff",         																	# optional
        			#expiry:            Time.now + 60*60,     																	# optional; 0 is default, meaning the message is not stored
        			#identifier:        1234,                 																	# optional; must be an integer
        			#content_available: true                  																	# optional; any truthy value will set 'content-available' to 1
      			)
      			pusher.push(notification)	
    			end	
        	render :status => 200,
          	     :json => { :success => true }
      	else
        	render :status => 400,
          	     :json => { :success => false }
      	end
			end
		else
			render :status => 400,
          	 :json => { :success => false }
		end	
	end

	def fetch_others_current_location
		if params[:meeting_detail_id].present? && params[:app_user_id].present?
			@journey = JourneyUpdate.where("meeting_detail_id =?", params[:meeting_detail_id]).where.not("app_user_id =?", params[:app_user_id])
			if @journey.present?
				render :status => 200,
               :json => { :success => true, :journey_update => @journey.as_json(:except => [:created_at, :updated_at]) }
			else
				render :status => 400,
               :json => { :success => false }
			end
		else
			render :status => 400,
               :json => { :success => false }
		end
	end

	private
	def journey_update_params
		params.permit(:meeting_detail_id, :app_user_id, :latitude, :longitude)
	end
end	