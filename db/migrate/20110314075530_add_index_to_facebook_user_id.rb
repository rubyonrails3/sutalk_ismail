class AddIndexToFacebookUserId < ActiveRecord::Migration
  def self.up
    add_index :users, :facebook_id
  end

  def self.down
    remove_index :users, :facebook_id
  end
end
