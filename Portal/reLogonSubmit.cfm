
<!--- resubmit data --->

<cfinclude template="Authent.cfm">

<cfif SESSION.authent eq "1">

	<cfset SESSION.isRelogon = "No">
	
	<script language="JavaScript">	
		    
		document.getElementById('relogonbox').style.display = "none"		
		
		// we try to also close additional information in the screen 
		try {
		document.getElementById('sessionexpirationbox').style.display = "none"	} catch(e) {}
		try {
		document.getElementById('sessionvalid').style.display = "none"	} catch(e) {}		
		document.getElementById('modalbg').style.display    = "none"
		sessionvalidatestart()
		
	</script>
	
	<font color="green">Entry accepted, please wait</font>

<cfelse>

	<!--- check how many times the user enters a wrong password 
	
	<cfset client.count = client.count+1>
	
	<cfif client.count eq "3">
	   
	    <script>
		 	 parent.window.returnValue = 9
			 parent.window.close()
		 </script>
		 
	</cfif>
	
	--->
	
	<font color="FF0000">Invalid account or password</font>
	 
</cfif>
