require 'rubygems'
require 'rest_client'

  
class Facebook 
 
  attr_accessor :token, :facebook_user, :friends, 
                :oauth_url, :onlineFriends, :friendsRandom   
  
  def initialize(params = {})  
    @token = getToken params
    @oauth_url = getOauthUrl params

    return if loggedout?

    @facebook_user = getUser
    @onlineFriends = getOnlineFriends
    @friendsRandom = getFriendsRandom
  end

  # get facebook oauth url
  def getOauthUrl params
    api = Sutalk::Application.config.facebook_api

    if params[:sid].nil?
      "#{api[:auth_url]}&redirect_uri=#{api[:canvas_page]}"    
    else
      "#{api[:auth_url]}&redirect_uri=#{api[:canvas_page]}?sid=#{params[:sid]}"    
    end
  end
  
  # logged out? Returns true if user is logged out.
  def loggedout?
     token.nil?
  end
      
  # get facebok user data
  def getUser 
    user = RestClient.get 'https://graph.facebook.com/me/', 
                          {:params => {:access_token => token}}
    ActiveSupport::JSON.decode user    
  end

  # get user's facebook friends
  def getFriends
    friends = RestClient.get 'https://graph.facebook.com/me/friends/', 
                             {:params => {:access_token => token}}
    ActiveSupport::JSON.decode friends
  end

  # get online friends
  def getOnlineFriends

    fql = "SELECT name, uid, first_name, profile_url, pic_square " + 
          "FROM user WHERE online_presence " +
          "IN ('active','idle') AND uid IN " + 
          "(SELECT uid2 FROM friend WHERE uid1=me()" +
          "ORDER BY rand()" + ")"
    
    facebook_api_fql_url = "https://api.facebook.com/method/fql.query"
    
    friends = RestClient.get facebook_api_fql_url, 
                            {:params => {:access_token => token, 
                                         :query => fql, 
                                         :format => "JSON"}}
    ActiveSupport::JSON.decode friends
  end

  # get all friends in random order
  def getFriendsRandom
    fql = "SELECT name, uid, first_name, profile_url, pic_square " + 
          "FROM user WHERE uid " +
          " IN (SELECT uid2 FROM friend WHERE uid1 = me())"  + 
          "ORDER BY rand()"
    
    facebook_api_fql_url = "https://api.facebook.com/method/fql.query"
    
    friends = RestClient.get facebook_api_fql_url, 
                            {:params => {:access_token => token, 
                                         :query => fql, 
                                         :format => "JSON"}}
    ActiveSupport::JSON.decode friends
  end

  
  protected 
  
  # get facebook token
  def getToken(params = {})  
    # dataSignedRequest = decode_facebook_hash(params["signed_request"])
    dataSignedRequest = getSignedRequest(params["signed_request"])
    token = dataSignedRequest["oauth_token"]
  end  

  # get signed request
  def getSignedRequest( signed_request )
    encoded_sig, payload = signed_request.split('.')
    data = ActiveSupport::JSON.decode base64_url_decode(payload)
                  # Don't bother with security of checking authenticity of token
    return data
  end

  # decode base 64 url
  def base64_url_decode str
      encoded_str = str.gsub('-','+').gsub('_','/')
      encoded_str += '=' while !(encoded_str.size % 4).zero?
      Base64.decode64(encoded_str)
  end
end
