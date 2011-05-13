class CreateRooms < ActiveRecord::Migration
  def self.up
    create_table :rooms do |t|
      t.string :opentok_id
      t.integer :count_users
      t.integer :status_id

      t.timestamps
    end
  end

  def self.down
    drop_table :rooms
  end
end
