window.addEventListener('load', function() {
	
	function sendIt( thingToSend ) {
		var xmlhttp = new XMLHttpRequest();   // new HttpRequest instance 
		
		// We define what will happen if the data are successfully sent
		xmlhttp.addEventListener('load', function(event) {
			document.write( event.target.responseText );
		});
		
		xmlhttp.open('POST', '/save-position');
		xmlhttp.setRequestHeader('Content-Type', 'application/json;charset=UTF-8');
		xmlhttp.send( thingToSend );
	}
	
	function sendMyPosition(position) {
//		document.write(position.coords.longitude + ' | ' + position.coords.latitude + ' | accuracy= ' + position.coords.accuracy + '<br>');
		var ratto = {
			lon: position.coords.longitude,
			lat: position.coords.latitude
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
	
	if ( 'geolocation' in navigator ) {
		navigator.geolocation.getCurrentPosition(sendMyPosition, error, options);
	} else {
		alert('Get rid of your fucking browser, you demented bastard!');
	}
	
	
	
});