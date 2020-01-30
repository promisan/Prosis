
<cfquery name="Get" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
    FROM   Employee.dbo.Person E
    WHERE  E.PersonNo = '#url.personno#'
</cfquery>

<cfoutput>

#Get.FirstName# #Get.LastName#

<script>
 document.getElementById('#url.function#').value = '#get.PersonNo#'
</script>

</cfoutput>
			