class CreateMeetingDetails < ActiveRecord::Migration
  def change
    create_table :meeting_details do |t|
    	t.integer :m_request_sender_id, null: false
    	t.integer :m_request_receiver_id, null: false
    	t.string :address
    	t.string :location
    	t.decimal :latitude, :precision => 18, :scale => 14
    	t.decimal :longitude, :precision => 18, :scale => 14
    	t.boolean :meeting_status, default: false
      t.timestamps null: false
    end
  end  
end
