class AddOpentokIdIndex < ActiveRecord::Migration
  def self.up
    add_index :rooms, :opentok_id
  end

  def self.down
    remove_index :rooms, :opentok_id
  end
end
