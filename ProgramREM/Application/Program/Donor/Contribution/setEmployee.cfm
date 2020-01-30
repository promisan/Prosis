
<cfquery name="Get" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
    FROM   Employee.dbo.Person E
    WHERE  E.PersonNo = '#url.personno#'
</cfquery>

<cfoutput>

<script>
 
 document.getElementById('personname').value  = '#get.FirstName# #get.LastName#'
 document.getElementById('personno').value    = '#get.PersonNo#'
 document.getElementById('indexno').value     = '#get.IndexNo#'

</script>

</cfoutput>
			