// Program: opentok_sdk.js
// Authors: Tokbox, Inc. Modified by Greg Wientjes.
// Date: 2-24-11
// Purpose: Opentok SDK



//--------------------------------------
//  LINK CLICK HANDLERS
//--------------------------------------

function connect() {
	session.connect(apiKey, token);
	show('publishLink');
	hide('connectLink');
}

function disconnect() {
	session.disconnect();
	hide('publishLink');
	hide('unpublishLink');
}

function publish() {
	if (!publisher) {
		var parentDiv = document.getElementById("myCamera");
		var div = document.createElement('div');			// Create a replacement div for the publisher
		div.setAttribute('id', 'opentok_publisher');
		parentDiv.appendChild(div);
		publisher = session.publish('opentok_publisher'); 	// Pass the replacement div id to the publish method
		show('unpublishLink');
		hide('publishLink');
	}
}

function unpublish() {
	if (publisher) {
		session.unpublish(publisher);
	}
	publisher = null;

	show('publishLink');
	hide('unpublishLink');
}

//--------------------------------------
//  OPENTOK EVENT HANDLERS
//--------------------------------------

function sessionConnectedHandler(event) {
	subscribeToStreams(event.streams);
	show('publishLink');
	hide('connectLink');
}

function streamCreatedHandler(event) {
	subscribeToStreams(event.streams);
}


function streamDestroyedHandler(event) {
	// This signals that a stream was destroyed. Any Subscribers will automatically be removed. 
	// This default behaviour can be prevented using event.preventDefault()
}

function sessionDisconnectedHandler(event) {
	// This signals that the user was disconnected from the Session. Any subscribers and publishers
	// will automatically be removed. This default behaviour can be prevented using event.preventDefault()
	publisher = null;
	
	show('connectLink');
	hide('publishLink');
	hide('unpublishLink');
}

function connectionDestroyedHandler(event) {
	// This signals that connections were destroyed
}

function connectionCreatedHandler(event) {
	// This signals new connections have been created.
}

/* 
If you un-comment the call to TB.setEventLister(), above, OpenTok 
calls the exceptionHandler() method when exception events occur. 
You can modify this method to further process exception events.
If you un-comment the call to TB.setLogLevel(), above, OpenTok 
automatically displays exception event messages. 
*/
function exceptionHandler(event) {
	alert("Exception: " + event.code + "::" + event.message);
}

//--------------------------------------
//  HELPER METHODS
//--------------------------------------

function subscribeToStreams(streams) {
	for (i = 0; i < streams.length; i++) {
		var stream = streams[i];
		addStream(stream);
	}
}

					// addStream function modified by Greg.
function addStream(stream) {
	// Check if this is the stream that I am publishing. If not,
	// we choose to subscribe to the stream.
	if (stream.connection.connectionId == session.connection.connectionId) {
		return;
	}
	var div = document.createElement('div');
	var divId = stream.streamId;
	div.setAttribute('id', divId);

	var subscribersContainer = document.getElementById('subscribersStartDiv');
	subscribersContainer.appendChild(div);

	var divProps = {width: 264, height: 198, audioEnabled:true}
	subscribers[stream.streamId] = session.subscribe(stream, divId, divProps);
}

function show(id) {
	document.getElementById(id).style.display = 'block';
}

function hide(id) {
	document.getElementById(id).style.display = 'none';
}
