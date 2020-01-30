
<cfparam name="Form.Pref_DashBoard" default="1:3:1">

<cfquery name="UpdateUser" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
UPDATE   UserNames 
SET      Pref_DashBoard     = '#Form.Pref_Dashboard#'  
WHERE    Account = '#SESSION.acc#'
</cfquery>

<script>
	history.go()
</script>

<!---
<cfoutput>#form.Pref_Dashboard#</cfoutput>	
--->
