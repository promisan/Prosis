 
<cfparam name="attributes.printer" default=""> 
<cfparam name="attributes.jquery" default="Yes">
 
<cfif attributes.jquery eq "Yes">
	<script type="text/javascript" src="<cfoutput>#SESSION.root#</cfoutput>/Scripts/jQuery/jquery.js"></script>
</cfif>	

<script type="text/javascript" src="<cfoutput>#SESSION.root#</cfoutput>/Scripts/qz-print/js/dependencies/rsvp-3.1.0.min.js?23"></script>
<script type="text/javascript" src="<cfoutput>#SESSION.root#</cfoutput>/Scripts/qz-print/js/dependencies/sha-256.min.js?23"></script>
<script type="text/javascript" src="<cfoutput>#SESSION.root#</cfoutput>/Scripts/qz-print/js/qz-tray.js?23"></script>


<script type="text/javascript">

	var root = '<cfoutput>#SESSION.root#</cfoutput>';
	
    function displayError(err) {
        console.error(err);
    }

</script>

