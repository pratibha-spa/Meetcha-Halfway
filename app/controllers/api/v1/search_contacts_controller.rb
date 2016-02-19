class Api::V1::SearchContactsController < ApplicationController
	skip_before_filter :verify_authenticity_token
	respond_to :json

	def search_through_contact
		#byebug
		contact_no_array = params[:contact_no_array]#.split(/,/)
		@contact_no_found = []
		contact_no_array.each do |contact|
			@app_user = AppUser.find_by_mobile_no(contact)
			if @app_user.present?
				@contact_no_found << @app_user
			end
		end
		render :json => { :contact_found => @contact_no_found.as_json(:only => [:id, :mobile_no] ) }
	end

	def show_meeting_history
		if params[:m_request_receiver_id].present?
			@meeting_history = MeetingDetail.where("m_request_receiver_id = ? AND meeting_status = ?", params[:m_request_receiver_id], false)
			if @meeting_history.present?
				render :status => 200,
               :json => { :success => true, :meeting_history => @meeting_history.as_json(:except => [:created_at, :updated_at], :methods => [:sender_mobile_no]) }
			else
			render :status => 400,
               :json => { :success => false }
			end
		else
			render :status => 400,
               :json => { :success => false }
		end
	end
end	