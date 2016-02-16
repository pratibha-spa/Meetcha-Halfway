class Api::V1::MeetingDetailsController < ApplicationController
	skip_before_filter :verify_authenticity_token
	respond_to :json

	def create_meeting
		@meeting = MeetingDetail.new(meeting_detail_params)
			if @meeting.save
				render :status => 200,
               		   :json => { :success => true, :meeting_id => @meeting.id }										
			end
	end

	private
	def meeting_detail_params
		params.permit(:m_request_sender_id, :m_request_receiver_id, :address, :location, :latitude, :longitude, :meeting_status)
	end
end	