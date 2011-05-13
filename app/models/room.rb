# == Schema Information
# Schema version: 20110305124426
#
# Table name: rooms
#
#  id          :integer         not null, primary key
#  opentok_id  :string(255)
#  count_users :integer
#  status_id   :integer
#  created_at  :datetime
#  updated_at  :datetime
#  name        :string(255)
#

require 'opentok_greg'

STATUS_INVITE = 2
ROOM_NAME_LENGTH = 6
# SEARCH_PARTNER_CYCLES = 4
# SLEEP_SECONDS = 1

class Room < ActiveRecord::Base
  attr_accessible :count_users, :opentok_id, :name, :status_id
  belongs_to :status
  has_many :presences
  has_many :users, :through => :presences
  
  before_save :initialize_name
  
  validates_presence_of :opentok_id
  
  def initialize_name  
    self.name = randomString
  end
  
  def self.getRoom( ip, sid )
    opentok_session = getOpentokSession ip, sid     
    
    if opentok_session[:new_session?]
      r = Room.create!( :opentok_id => opentok_session[:sessionId], 
                    :status_id => STATUS_INVITE, 
                    :count_users => 0)      
      
      opentok_session[:room_id] = r.id        
    end        
    opentok_session
    
  end
  
  # Returns an OpenTok session ID for user to meet with a new person, assigned
  # as a partner based on available flag random selection from user table.
  def self.getRoomNewFriends( ip, sid, facebook_id )
    user = User.find_by_facebook_id facebook_id
    Presence.clearUser user
    user.available
    # user.unavailable
    
    partner = User.searchForPartner user
    room = Room.getRoomWithPartner user, partner, ip

    p "partner"
    p partner
    
    # # sid = "170f67b8c9bd095262d16ea2de3ccca576cb6625"
    #    
    # room = Room.getRoom ip, nil
    # 
    # Presence.assignRoom room, user, partner 
    # 
    # # user.unavailable
    # # partner.unavailable
    
    room
  end
  
  private  
  
  
  def self.getRoomWithPartner( user, partner, ip )
    # sid = "170f67b8c9bd095262d16ea2de3ccca576cb6625"
   
    room = Room.getRoom ip, nil

    Presence.assignRoom room, user, partner 
    
    # user.unavailable
    # partner.unavailable
    room
  end
  
  # return a random string of letter and number, case sensitive
  def randomString
    o =  [('a'..'z'),('A'..'Z'),(0..9)].map{|i| i.to_a}.flatten  
    string  =  (1..ROOM_NAME_LENGTH).map{ o[rand(o.length)]  }.join
  end
  
  def self.getOpentokSession( ip, sid )
    opentok_api = OpentokApi.new ip, sid
    opentok_session = opentok_api::opentok_session  
  end
  
end


