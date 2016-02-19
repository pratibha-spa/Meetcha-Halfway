class MeetingDetail < ActiveRecord::Base
	def sender_mobile_no
		@mobile_no = AppUser.where("id =?", m_request_sender_id).take.mobile_no
	end
end
