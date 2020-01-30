
<!--- we restart the session tracker once we determine that session authent has value 1 --->

<cfparam name="SESSION.authent" default="0">

<cf_compression>

<cfif SESSION.authent eq "1">

	<script language="JavaScript">	
	  
	   try {
	   
	     // we restart the validation interval		
		 sessionvalidatestart()	
		 
		 // hide the dialog screens
		 document.getElementById('relogonbox').style.display  = "none"
		 document.getElementById('modalbg').style.display     = "none"
		 } catch(e) {}
		 
		 // try {
		 // document.getElementById('sessionvalid').style.display = "none"	} catch(e) {}	
		 
		 // stop this 2nd layer process
		 sessioninitvalidatestop() 
		 
	</script>	
	
<cfelse>

	<!--- do nothing and wait for the other screens to responds with a authenticated session  --->	
		
</cfif>		

