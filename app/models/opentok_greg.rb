require 'rubygems'
require 'lib/opentok'

# STATUS_INVITE = 2
# ROOM_NAME_LENGTH = 6

  
class OpentokApi
  attr_accessor :opentok_session

  def initialize(ip, sid)  
    @opentok_session = getOpentokSession ip, sid
  end

  private
  
  def getOpentokSession( ip, sid )
    opentok = Sutalk::Application.config.opentok_api
    
    o = OpenTok::OpenTokSDK.new opentok[:api_key], opentok[:api_secret]
    o.api_url = opentok[:api_url]
    
    session_id = getSessionId o, ip, sid        
    token = getToken o, session_id

    opentok_session = { 
                        :apiKey => opentok[:api_key],
                        :sessionId => session_id,
                        :token => token,
                        :new_session? => @isNewSession
                      }
  end
  
  def getSessionId( o, ip, sid)
    if sid.nil?
      @isNewSession = true
      session = o.create_session( ip, OpenTok::SessionPropertyConstants::ECHOSUPPRESSION_ENABLED=>"true" )
      # saveRoom session
      # Room.create!( :opentok_id => session::session_id, 
      #               :status_id => STATUS_INVITE, 
      #               :count_users => 0)
      session::session_id
    else
      @isNewSession = false
      sid
    end
  end
  
  def getToken o, session_id
    sessionHash = { :session_id => session_id }
    token = o.generate_token sessionHash  
  end
  
end
