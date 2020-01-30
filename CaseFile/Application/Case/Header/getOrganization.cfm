
<cfquery name="qOrganization" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Organization
		WHERE  OrgUnit = '#url.Orgunit#'
</cfquery>

<cfoutput>
<script>
	$('##orgunitname').val('#qOrganization.orgUnitName#');
	$('##mission').val('#qOrganization.Mission#');
	$('##orgunit').val('#qOrganization.orgunit#');
	$('##orgunitcode').val('#qOrganization.orgunitcode#');
	$('##orgunitclass').val('#qOrganization.orgunitclass#');
</script>
</cfoutput>