
<!--- we restart the session tracker once we determine that session authent has value 1 --->

<cfparam name="SESSION.authent" default="0">

<cfif SESSION.authent eq "1">

	<script language="JavaScript">	
	  	  
	   try {
	   
	     // we restart the validation interval		
		 sessionvalidatestart()	
		 ProsisUI.closeWindow('relogonbox')    	
		 
		 } catch(e) {}
		 
		 // stop this 2nd layer process
		 sessioninitvalidatestop() 
		 
	</script>	
	
<cfelse>

	<!--- do nothing and wait for the other screens to responds with a authenticated session  --->	
		
</cfif>		

