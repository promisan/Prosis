<cfoutput>

<script>

function validateinsurance(frm,job,ven) {
	
	document.getElementById(frm).onsubmit()
		
	if( _CF_error_messages.length == 0 ) {	          
		ColdFusion.navigate('#SESSION.root#/procurement/application/quote/Insurance/InsuranceSubmit.cfm?jobno='+job+'&orgunit='+ven,'detail','','','POST',frm)
	 }   
	 
	 }

</script>

</cfoutput>