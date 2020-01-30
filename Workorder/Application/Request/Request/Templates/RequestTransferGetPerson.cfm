
<cfquery name="Person" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Person
		WHERE  PersonNo = '#url.personNo#'	
</cfquery>

<cfoutput>

<cfif url.personno neq "">
	
	<cfoutput>
		<script>	 	  
		  document.getElementById('personnoto').value        = '#url.personno#'	
		  document.getElementById('toname').innerHTML        = '#REPLACE(Person.FirstName,"'","","ALL")# #REPLACE(Person.LastName,"'","","ALL")#'	
		  document.getElementById('toindexno').innerHTML     = '#Person.IndexNo#'	
		  document.getElementById('togender').innerHTML      = '#Person.Gender#'	
		  document.getElementById('tonationality').innerHTML = '#Person.Nationality#'	  
		</script>
	</cfoutput>

</cfif>

</cfoutput>