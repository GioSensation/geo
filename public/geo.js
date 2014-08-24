window.addEventListener('load', function() {
	
	function sendIt( thingToSend ) {
		var xmlhttp = new XMLHttpRequest();   // new HttpRequest instance 
		
		// We define what will happen if the data are successfully sent
		xmlhttp.addEventListener('load', function(event) {
			document.getElementById('response').innerHTML = event.target.responseText ;
		});
		
		xmlhttp.open('PATCH', '/save-coords');
		xmlhttp.setRequestHeader('Content-Type', 'application/json;charset=UTF-8');
		xmlhttp.send( thingToSend );
	}
	
	function sendMyPosition(position) {
//		document.write(position.coords.longitude + ' | ' + position.coords.latitude + ' | accuracy= ' + position.coords.accuracy + '<br>');
		var ratto = {
			latitude: position.coords.latitude,
			longitude: position.coords.longitude,
		};
		ratto = JSON.stringify( ratto );
		sendIt( ratto );
	};
	
	function error(err) {
		console.warn('ERROR(' + err.code + '): ' + err.message);
	};
	
	options = {
		enableHighAccuracy: true,
		timeout: 27000,
		maximumAge: 30000
	};
	
	function geolocateMe() {
		if ( 'geolocation' in navigator ) {
			navigator.geolocation.getCurrentPosition(sendMyPosition, error, options);
		} else {
			alert('Get rid of your fucking browser, you demented bastard!');
		}
	}
	
	var sendLocation = document.getElementById('sendLocation');
	if ( sendLocation ) {
		sendLocation.addEventListener('click', geolocateMe);
	}
	
});