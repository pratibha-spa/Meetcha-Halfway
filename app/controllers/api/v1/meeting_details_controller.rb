class Api::V1::MeetingDetailsController < ApplicationController
	skip_before_filter :verify_authenticity_token
	respond_to :json

	def create_meeting
		@app_user = AppUser.where("id = ?", params[:m_request_receiver_id] ).take
		@meeting_detail = MeetingDetail.new(meeting_detail_params)
		msg = @meeting_detail.to_json(:except => [:created_at, :updated_at], :methods => [:sender_mobile_no]).gsub!(/\"/, '\'')
			if @meeting_detail.save
				if @app_user.device_flag == "android"
					gcm = GCM.new("AIzaSyC7tEx94lVkuevlmRu2g5CDXQkX7exMyw0")
    			registration_id = ["#{@app_user.device_token}"]
    			gcm.send(registration_id, {data: {message: "#{msg}"}})
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
        		alert:             "#{msg}",
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
               		   :json => { :success => true, :meeting_id => @meeting_detail.id }										
			end
	end

	def update_meeting
		@meeting_detail = MeetingDetail.find_by_id(params[:meeting_id])
		if @meeting_detail.present?
			@meeting_detail.meeting_status == true
			@meeting_detail.save!
			render :status => 200,
               		   :json => { :success => true }
		else
			render :status => 400,
               :json => { :success => false }
		end
	end

	private
	def meeting_detail_params
		params.permit(:m_request_sender_id, :m_request_receiver_id, :address, :location, :latitude, :longitude, :meeting_status)
	end
end	