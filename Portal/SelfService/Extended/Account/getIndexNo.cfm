

<!--- get IndexNo --->

<cfquery name="getPerson" 
	datasource="appsEmployee">
	SELECT   * 
	FROM     Person
    WHERE    IndexNo LIKE '%#url.IndexNo#%'
</cfquery>	

<cfoutput>

<cfif getPerson.recordcount eq "1">

	<script language="JavaScript">
	
	 document.getElementById('lastname').value   = '#getPerson.LastName#'
	 document.getElementById('firstname').value  = '#getPerson.FirstName#'
	
	 <cfif getPerson.Gender eq "M">
	  document.getElementById('gender').selectedIndex = 0
	 <cfelse>
	  document.getElementById('gender').selectedIndex = 1   
 	 </cfif>
	 document.getElementById('emailaddress').focus()
	 	 
	</script>
	
	<font face="Calibri" color="008080">Valid!</font>	


<cfelse>

	<font face="Calibri" color="red">Not found!</font>	

</cfif>	 

</cfoutput>