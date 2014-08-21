window.addEventListener('load', function() {
	
	function getMyPosition(position) {
//		document.write(position.coords.longitude + ' | ' + position.coords.latitude + ' | accuracy= ' + position.coords.accuracy + '<br>');
		var ratto = {
			lon: position.coords.longitude,
			lat: position.coords.latitude,
			acc: position.coords.accuracy,
		};
		document.write( JSON.stringify(ratto) + '<br>' );
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
		navigator.geolocation.watchPosition(getMyPosition, error, options);
	} else {
		alert('Get rid of your fucking browser, you demented bastard!');
	}
});