class JourneyUpdatesController < ApplicationController
	def index
		@journeys = JourneyUpdate.all
	end

	def destroy
    @journey = JourneyUpdate.find(params[:id])
    respond_to do |format|
      if @journey.destroy
        format.html { redirect_to journey_updates_path, :notice => 'Successfully removed.' }
        format.xml  { render :xml => @journey, :status => :created, :journey_update => @journey }
      end
    end
  end
  private
	def journey_update_params
		params.permit(:meeting_detail_id, :app_user_id, :latitude, :longitude)
	end
end	