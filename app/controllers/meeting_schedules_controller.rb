class MeetingSchedulesController < ApplicationController
	def index
		@meetings = MeetingSchedule.all
	end

	def destroy
    @meeting = MeetingSchedule.find(params[:id])
    respond_to do |format|
      if @meeting.destroy
        format.html { redirect_to meeting_schedules_path, :notice => 'Successfully removed.' }
        format.xml  { render :xml => @meeting, :status => :created, :meeting_schedule => @meeting }
      end
    end
  end
  private
	def meeting_schedule_params
		params.permit(:m_request_sender_id, :m_request_receiver_id, :address, :location, :latitude, :longitude, :meeting_status)
	end
end	