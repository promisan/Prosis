
<cfoutput>


<cfquery name="get" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT * FROM UserNames
	WHERE  Account = '#url.useraccount#'	
</cfquery>

<cfset name = replaceNoCase("#get.FirstName# #get.LastName#","'","ALL")>

<script>
  
document.getElementById('requester').value = '#url.useraccount#'  
document.getElementById('email').value     = '#get.eMailAddress#'
 
 try {
   document.getElementById('requestername').value = '#name#'
  } catch(e) {}
  
</script>
</cfoutput>
