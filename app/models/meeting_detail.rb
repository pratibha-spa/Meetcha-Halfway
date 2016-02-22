class MeetingDetail < ActiveRecord::Base
	def as_json(opts={})
    json = super(opts)
    Hash[*json.map{|k, v| [k, v || ""]}.flatten]
  end
	def sender_mobile_no
		@mobile_no = AppUser.where("id =?", m_request_sender_id).take.mobile_no
	end
end
