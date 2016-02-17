class CreateJourneyUpdates < ActiveRecord::Migration
  def change
    create_table :journey_updates do |t|
    	t.belongs_to :meeting_detail, index: true
    	t.belongs_to :app_user, index: true
    	t.decimal :latitude, :precision => 18, :scale => 14
    	t.decimal :longitude, :precision => 18, :scale => 14
      t.timestamps null: false
    end
  end
end
