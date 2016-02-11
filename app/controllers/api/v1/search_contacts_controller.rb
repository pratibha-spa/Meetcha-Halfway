class Api::V1::SearchContactsController < ApplicationController
	skip_before_filter :verify_authenticity_token
	respond_to :json

	def search_through_contact
		#byebug
		contact_no_array = params[:contact_no_array]#.split(/,/)
		contact_no_found = []
		contact_no_array.each do |contact|
			@app_user = AppUser.find_by_mobile_no(contact)
			if @app_user.present?
				contact_no_found << contact
			end
		end
		render :json => { :contact_found => contact_no_found.as_json }
	end
end	