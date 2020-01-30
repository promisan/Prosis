
<cfquery name="Parameter" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM  Ref_ParameterMission
	WHERE Mission = '#URL.Mission#' 
</cfquery>

<cfoutput>
<script>
	window.location = "../../../../System/Organization/Application/OrganizationView.cfm?systemfunctionid=#url.systemfunctionid#&mode=limited&mission=#Parameter.TreeDonor#"
</script>
</cfoutput>
