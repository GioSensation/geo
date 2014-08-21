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
	
	function sendData(position) {
		var XHR = new XMLHttpRequest();

		// We bind the FormData object and the form element
		var FD  = new FormData(theForm);

		// We define what will happen if the data are successfully sent
		XHR.addEventListener("load", function(event) {
			wait.className = wait.className.replace( /(?:^|\s)showWait(?!\S)/g , '' );
			scrollTo(document.getElementById('contact-page').offsetTop - 80, 400);
			formContainer.innerHTML = event.target.responseText;
		});

		// We define what will happen in case of error
		XHR.addEventListener("error", function() {
			window.alert('Oups! Something goes wrong.');
		});

		// We setup our request
		XHR.open("POST", "contact.php");

		// The data sent are the one the user provide in the form
		XHR.send(FD);
	}
});