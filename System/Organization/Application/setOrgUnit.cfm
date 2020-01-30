
<!--- set orgunit --->

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


    document.getElementById("#url.field##url.scope#").value         = "#get.OrgUnit#"				
    document.getElementById("#url.field#name#url.scope#").value     = "#get.OrgUnitName#"	
		
	try {
	document.getElementById("mission#url.scope#").value  = "#get.Mission#"			
	} catch(e) {}
	try {
	document.getElementById("#url.field#mission#url.scope#").value  = "#get.Mission#"			
	} catch(e) {}
	try {
	document.getElementById("#url.field#code#url.scope#").value  = "#get.OrgUnitCode#"			
	} catch(e) {}
	try {
	document.getElementById("#url.field#class#url.scope#").value  = "#get.OrgUnitClass#"			
	} catch(e) {}
	
	
	
</script>	

</cfoutput>