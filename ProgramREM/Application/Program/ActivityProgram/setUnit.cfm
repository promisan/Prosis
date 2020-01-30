<cfquery name="getUnit" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     Organization
		WHERE    OrgUnit = '#URL.OrgUnit#'
</cfquery>

<cfoutput>
	<script>
		$('##orgunitclass').val('#getUnit.orgunitclass#');
		$('##mission').val('#getUnit.mission#');
		$('##orgunitcode').val('#getUnit.orgunitcode#');
		$('##orgunit').val('#getUnit.orgunit#');
		$('##orgunitname').val('#getUnit.OrgUnitName#');
	</script>
</cfoutput>