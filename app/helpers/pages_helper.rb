module PagesHelper

  # Link to Facebook profile
  def link(id)
    "http://www.facebook.com/profile.php?id=#{id}"
  end
  
  # Photo of Facebook user
  def photo(id)
    image_tag "http://graph.facebook.com/#{id}/picture?type=square", 
              :class => "friendWallPhoto round"
  end
    
  # Photo of user linked to profile url
  def photoLinked( id )
    link_to photo( id ), link( id ), :target => "_blank" 
  end  

  # Photo of user with Request Dialogue action to initiate SUtalk session
  def photoRequest( id )
    image_tag "http://graph.facebook.com/#{id}/picture?type=square", 
              :class => "friendWallPhoto round", 
              'data-facebook-uid' => "#{id}"
  end  
  
  # Name of user with link to profile url
  def name( user )
    link_to user["first_name"][0..8], link( user["uid"] ), :target => "_blank"
  end
  
  # Online Friend, includes photo of user with Request Dialogue and Name linked
  def friendOnline( user )
    photoRequest( user["uid"] ) + raw("<br />") +
    name( user )
  end
  
  def displayFriendPanel( friends, max )

    if friends.empty? 
       return 
	  end
	  
	  html = ""
	  
	  friends[0..max].each do |f|  
		    html += "<div class='online_friend'>" +
			          friendOnline(f) + 
		            "</div>" 
	  end 
	  html
  end
   
  # Invite friends to SUtalk, if opentok session ID is not present
  def facebookJavascriptOnload
    if @opentok_session[:new_session?]
      "inviteAllOnlineFriends();"   
    else
      "setCanvasHeight(1400);"
    end
  end  
end
