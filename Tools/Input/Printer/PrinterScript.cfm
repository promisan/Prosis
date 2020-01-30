<script>
var _enabled_printers_ = new Array();

function qzReady() {
	// Setup our global qz object
		window["qz"] = document.getElementById('qz');
		var title = document.getElementById("_printer_message_");
		if (qz) {
			try {
				title.innerHTML = qz.getVersion();
				findPrinters();
								
			} catch(err) {
				alert('error'); 
	  	}
  }
}


/***************************************************************************
* Prototype function for listing all printers attached to the system
* Usage:
*    qz.findPrinter('\\{dummy_text\\}');
*    window['qzDoneFinding'] = function() { alert(qz.getPrinters()); };
***************************************************************************/
function findPrinters() {
		if (isLoaded()) {
			// Searches for a locally installed printer with a bogus name
			qz.findPrinter('\\{bogus_printer\\}');
			
			// Automatically gets called when "qz.findPrinter()" is finished.
			window['qzDoneFinding'] = function() {
				// Get the CSV listing of attached printers
				var connected_printers = qz.getPrinters().split(',');
				var configured_printer = document.getElementById("_printer_devices_").value.split(',');
				
				var terminal = document.getElementById("terminal");
				
				if (terminal)
				{
					var found = false;
					$.each(connected_printers, function( index, value ) {
						if (jQuery.inArray( value, configured_printer )>=0)
						{
							//Found//
							found = true;
							terminal.value = value; 
							document.getElementById("_printer_message_").innerHTML = 'Terminal: '+value+' found';
						}
	  					
					});
					
					if (!found)
						document.getElementById("_printer_message_").innerHTML = 'Terminal not found';
						 
				}	
				else
				{
					document.getElementById("_printer_message_").innerHTML = 'Error loading page';					
				}
				 
				 
				
				
				// Remove reference to this function
				window['qzDoneFinding'] = null;
			};
		}
}

// Returns whether or not the applet is not ready to print.
// Displays an alert if not ready.

function notReady() {
	// If applet is not loaded, display an error
	if (!isLoaded()) {
		return true;
	}
	// If a printer hasn't been selected, display a message.
	else if (!qz.getPrinter()) {
		alert('Please select a printer first by using the "Detect Printer" button.');
		return true;
	}
	return false;
}

// Returns is the applet is not loaded properly

function isLoaded() {
	if (!qz) {
		alert('Error:\n\n\tPrint plugin is NOT loaded ERR!');
		return false;
	} else {
		try {
			if (!qz.isActive()) {
				alert('Error:\n\n\tPrint plugin is loaded but NOT active!');
				return false;
			}
		} catch (err) {
			alert('Error:\n\n\tPrint plugin is NOT loaded properly!');
			return false;
		}
	}
	return true;
}

function findPrinter(_printer_name) {

	if (isLoaded()) {
		// Searches for locally installed printer with specified name
		qz.findPrinter(_printer_name);
		
		// Automatically gets called when "qz.findPrinter()" is finished.
		window['qzDoneFinding'] = function() {
			var p = document.getElementById('printer');
			
			window['qzDoneFinding'] = null;
		};
	}

}

// Automatically gets called when "qz.print()" is finished.

function qzDonePrinting() {
		// Alert error, if any
	if (qz.getException()) {
			alert('Error printing:\n\n\t' + qz.getException().getLocalizedMessage());
			qz.clearException();
			return; 
	}
		
}






</script>