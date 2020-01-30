<cfquery name="InsertOwner" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">

		DELETE 
		FROM	ServiceItemUnitMissionOrgUnit
		WHERE	CostId = '#url.costId#'
		AND		OrgUnitOwner = '#url.orgUnit#'
	
</cfquery>

<cfoutput>
	<script>
		ColdFusion.navigate('OrgUnitOwnerList.cfm?orgUnit=&costId=#url.costId#','divOrgUnitOwnerList');
	</script>
</cfoutput>