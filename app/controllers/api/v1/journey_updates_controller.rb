class Api::V1::JourneyUpdatesController < ApplicationController
	skip_before_filter :verify_authenticity_token
	respond_to :json

	def save_your_current_location
		@journey = JourneyUpdate.find_by_meeting_detail_id_and_app_user_id(params[:meeting_detail_id],params[:app_user_id])
		if @journey.present?
			@journey.update(journey_update_params)
        render :status => 200,
               :json => { :success => true }
		else
			@journey = JourneyUpdate.new(journey_update_params)
			if @journey.save
        render :status => 200,
               :json => { :success => true }
      else
        render :status => 400,
               :json => { :success => false }
      end
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