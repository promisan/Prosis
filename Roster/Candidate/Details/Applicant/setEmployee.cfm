
<!--- set employee --->


<cfquery name="Person" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT * 
    FROM Person
	WHERE PersonNo = '#url.PersonNo#'
</cfquery>

<cfoutput>
	
	<script>
	
		document.getElementById('indexno').value       = '#Person.IndexNo#' 
		document.getElementById('employeeno').value    = '#Person.PersonNo#'
		document.getElementById('lastname').value      = '#Person.LastName#'
		document.getElementById('firstname').value     = '#Person.FirstName#'
		<cfif Person.MaritalStatus neq "">
		document.getElementById('maritalstatus').value = '#Person.MaritalStatus#'						
		</cfif>
		document.getElementById('emailaddress').value  = '#Person.eMailAddress#'				
		document.getElementById('#Person.gender#gender').click()
		document.getElementById('DOB').value           = '#dateformat(Person.BirthDate,client.dateformatshow)#'
		document.getElementById('Nationality').value   = '#Person.Nationality#'
	</script>

</cfoutput>