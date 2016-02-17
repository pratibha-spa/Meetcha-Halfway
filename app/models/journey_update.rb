class JourneyUpdate < ActiveRecord::Base
	belongs_to :meeting_detail
	belongs_to :app_user
end
