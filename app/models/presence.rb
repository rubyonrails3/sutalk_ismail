# == Schema Information
# Schema version: 20110315184642
#
# Table name: presences
#
#  id         :integer         not null, primary key
#  room_id    :integer
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class Presence < ActiveRecord::Base
  belongs_to :user
  belongs_to :room
  
  def self.assignRoom( room, user1, user2 )
    Presence.create!( :room_id => room[:room_id], :user_id => user1.id )
    Presence.create!( :room_id => room[:room_id], :user_id => user2.id )  
  end
    
  def self.clearUser( user )
    Presence.delete_all(["user_id = ?", user.id])    
  end
  
end
