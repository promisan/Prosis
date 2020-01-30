
<!--- set the selected account --->

<cfquery name="get" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
		FROM   Organization
		WHERE  OrgUnit = '#URL.orgunit#'
	</cfquery>

<cfoutput>
	
<script>
    document.getElementById("#url.field#").value         = "#get.OrgUnit#"		
    document.getElementById("#url.field#name").value     = "#get.OrgUnitName#"	
	document.getElementById("#url.field#mission").value  = "#get.Mission#"			
</script>	

</cfoutput>