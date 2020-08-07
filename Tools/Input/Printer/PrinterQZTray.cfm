 
<cfparam name="attributes.printer" default=""> 
<cfparam name="attributes.jquery" default="Yes">
<cfparam name="attributes.useDefault"   default="No">
 
<cfif attributes.jquery eq "Yes">
	<script type="text/javascript" src="<cfoutput>#SESSION.root#</cfoutput>/Scripts/jQuery/jquery.js"></script>
</cfif>	

<script type="text/javascript" src="<cfoutput>#SESSION.root#</cfoutput>/Scripts/qz-print-2.0/js/dependencies/rsvp-3.1.0.min.js"></script>
<script type="text/javascript" src="<cfoutput>#SESSION.root#</cfoutput>/Scripts/qz-print-2.0/js/dependencies/sha-256.min.js"></script>
<script type="text/javascript" src="<cfoutput>#SESSION.root#</cfoutput>/Scripts/qz-print-2.0/js/qz-tray.js"></script>


<script type="text/javascript">

	var root = '<cfoutput>#SESSION.root#</cfoutput>';
	
    function displayError(err) {
        console.error(err);
    }


	var i=0;
	var doc=1;
	var vall=26;

 	
	function getPath() {
		var path = window.location.href;
		return path.substring(0, path.lastIndexOf("/")) + "/";
	}


	
	qz.security.setCertificatePromise(function(resolve, reject) {
		$.ajax(root+'/tools/input/printer/promisan2020.txt').then(resolve, reject);
	});
	
	
	qz.security.setSignaturePromise(function(toSign) {
	    return function(resolve, reject) {
			$.ajax(root + '/tools/input/printer/signMessage2.0.cfm?request=' + toSign).then(resolve, reject);
	    };
	});


qz.websocket.setErrorCallbacks(handleConnectionError);

  /// Connection ///
    function launchQZ() {
        if (!qz.websocket.isActive()) {
            //Retry 5 times, pausing 1 second between each attempt
            startConnection({ retries: 5, delay: 1 });
        }
    }

    function startConnection(config) {
        if (!qz.websocket.isActive()) {

            qz.websocket.connect(config).then(function() {
              <cfif attributes.useDefault eq "No">
                    doPrint();
                <cfelse>
                    findDefaultPrinter(true);
                </cfif>
            }).catch(handleConnectionError);
        } else {
            doPrint();
        }
    }

    function endConnection() {
        if (qz.websocket.isActive()) {
            qz.websocket.disconnect().then(function() {
                
            }).catch(handleConnectionError);
        } else {
            displayMessage('No active connection with QZ exists.', 'alert-warning');
        }
    }
    
    
    function handleConnectionError(err) {

        if (err.target != undefined) {
            if (err.target.readyState >= 2) { //if CLOSING or CLOSED
                displayError("Connection to QZ Tray was closed");
            } else {
                console.error(err);
            }
        } else {
        	console.error(err);
        }
    }
    


</script>

