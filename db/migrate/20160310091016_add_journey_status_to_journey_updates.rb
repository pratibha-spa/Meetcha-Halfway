class AddJourneyStatusToJourneyUpdates < ActiveRecord::Migration
  def change
  	add_column :journey_updates, :journey_status, :boolean, default: true
  end
end
