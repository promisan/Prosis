
<!--- saving customer record --->
  
<cfquery name="Check" 
datasource="#url.dsn#" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
		DELETE FROM  Customer		
		WHERE  CustomerId = '#url.CustomerId#'		
</cfquery>	 

<cfoutput>

	  <script language="JavaScript">
	   		
		opener.customeredit('#url.customerid#')
	    window.close()  				       
   </script>	  
					
</cfoutput>
