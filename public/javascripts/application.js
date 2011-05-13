// SUtalk Javascript


$(document).ready(function(){
	
			// OpenTok Initialization
	if (TB.checkSystemRequirements() != TB.HAS_REQUIREMENTS) {
		alert('Minimum System Requirements not met!');
	} else {
		session = TB.initSession(sessionId);	// Initialize session

		// Add event listeners to the session
		session.addEventListener('sessionConnected', sessionConnectedHandler);
		session.addEventListener('sessionDisconnected', sessionDisconnectedHandler);
		session.addEventListener('connectionCreated', connectionCreatedHandler);
		session.addEventListener('connectionDestroyed', connectionDestroyedHandler);
		session.addEventListener('streamCreated', streamCreatedHandler);
		session.addEventListener('streamDestroyed', streamDestroyedHandler);
	}	
	
	connect();			// connect to tokbox


										// SUtalk Links
  $("#invite_link").click(function(event){
		checkOnlinePrescencePermission();	
		inviteAllOnlineFriends(); 
		event.preventDefault();
  });

  $("#onlineFriendsTitle").click(function(event){
		checkOnlinePrescencePermission();	
		inviteAllOnlineFriends();
		event.preventDefault();
  });

 	$(".sutalkLink").click(function(event){
		$(this).focus();
    $(this).select();
	});
	
										// opentok controls
  $("#connectLink").click(function(event){
		connect(); 
		event.preventDefault();
  });

  $("#publishLink").click(function(event){
		publish(); 
		event.preventDefault();
  });

  $("#unpublishLink").click(function(event){
		unpublish(); 
		event.preventDefault();
  });
	
  $("#connectInstructions").click(function(event){
		connect(); 
		event.preventDefault();
  });

  $("#publishInstructions").click(function(event){
		publish(); 
		event.preventDefault();
  });

					// facebook
 	$(".friendWallPhoto").click(function(event){
		inviteSingle($(this).data("facebook-uid"));
		event.preventDefault();
	});

 	$(".new_friends_button").click(function(event){
		// disconnect();
	});
		

		
});
