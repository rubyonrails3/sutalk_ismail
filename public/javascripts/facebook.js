// Program: facebook.js
// Author: Greg Wientjes
// Date: 2-24-11
// Purpose: Facebook javascript library

// var onlineFriends;

// alert('hello world');

var CANVAS_HEIGHT_SMALL = 600;
var CANVAS_HEIGHT_LARGE = 1400;

function inviteAllOnlineFriends(){ 
	setCanvasHeight(CANVAS_HEIGHT_SMALL);
	getOnlineFriends();
}
 


// Get online friends.  Returns an array of facebook user ids of online friends
function getOnlineFriends(){
	var fql = "SELECT uid FROM user WHERE online_presence IN ('active','idle') AND uid IN (SELECT uid2 FROM friend WHERE uid1=me())";
	
	var query = FB.Data.query(fql);

	query.wait(function(rows) {
		requestInvite( rows );
	});
}

// Check facebook permission for retrieving user's online friends' prescence
function checkOnlinePrescencePermission(){
	
	FB.api(
	  {
	    method: 'fql.query',
	    query: 'SELECT friends_online_presence FROM permissions WHERE uid = me()'
	  },
	  function(response) { 
			if(response[0].friends_online_presence == 0){
				FB.login(function(response) {}, {perms:'friends_online_presence'});				
			}
		}
	);
}

function requestInvite( onlineFriends ){
	var onlineFriendsArray = jsonToArrayOfValues(onlineFriends);
	
	var message = 'Please SUtalk video chat with me at ' +
	 							fb_api.canvas_page + '?sid=' + opentok.session_id;
	
	FB.ui({	method: 'apprequests', 
					message: message,
					title: 'Select Online Friends To SUtalk Video Chat', 
					filters: [{name: 'Online Friends', user_ids: onlineFriendsArray}, 'all' ]
				},
				function(response) {
						feedInvite();	
				}
	);
}

// convert json object to an array of values
function jsonToArrayOfValues(json){
	var arr=new Array(); 
	for (i=0;i<json.length;i++){
		arr.push(json[i].uid);
	}
	
	return arr;
}

feedInvite = function feedInvite(){
	FB.ui(
	   {
	     method: 'feed',
	     name: 'Invite your friends to SUtalk video chat',
	     link: fb_api.canvas_page + '?sid=' + opentok.session_id,
			 picture: 'http://sutalk.heroku.com/images/logo.png',
	     message: 'Please SUtalk video chat with me at ' +
	 							fb_api.canvas_page + '?sid=' + opentok.session_id
	   },
		 function(response) {
				setCanvasHeight(CANVAS_HEIGHT_LARGE);	
		 }
	 );
}

// Set canvas height
setCanvasHeight = function setCanvasHeight(h){
	FB.Canvas.setSize({ height: h });		
}

// Invite a single friend to SUtalk video chat using a dialogue request
function inviteSingle(id){
	setCanvasHeight(CANVAS_HEIGHT_SMALL);
	var message = 'Please SUtalk video chat with me at ' +
	 							fb_api.canvas_page + '?sid=' + opentok.session_id;
	
	FB.ui({	method: 'apprequests', 
					message: message,
					title: 'Invite Friend To SUtalk Video Chat', 
					to: id
				},
				function(response) {
					setCanvasHeight(CANVAS_HEIGHT_LARGE);
				}
	);
}

