
<!--- get the person --->

<cfquery name="get" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM   Person
	WHERE  PersonNo = '#url.PersonNo#'	
</cfquery>

<cfoutput>

<script>

 document.getElementById('indexno').value   = "#get.IndexNo#"
 document.getElementById('personno').value  = "#get.PersonNo#"
 document.getElementById('lastname').value  = "#get.LastName#"
 document.getElementById('firstname').value = "#get.FirstName#" 
 <cfif get.Gender eq "M">
  document.getElementById('male').checked   = true
 <cfelse>
  document.getElementById('female').checked = true  
 </cfif>
</script>

</cfoutput>