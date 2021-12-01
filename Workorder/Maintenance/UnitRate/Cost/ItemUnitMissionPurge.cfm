
<cftransaction>
	
	<cfquery name="clearLines" 
		datasource="AppsWorkorder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			DELETE
			FROM   	ServiceItemUnitMissionRemuneration
			WHERE	CostId = '#URL.ID3#'
	</cfquery>

	<cfquery name="Delete" 
	datasource="AppsWorkorder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM ServiceItemUnitMission
		WHERE costId = '#URL.ID3#'
	</cfquery>	

</cftransaction>

<cfoutput>
<script language="JavaScript">   
	ColdFusion.navigate('#SESSION.root#/workorder/maintenance/unitRate/ItemUnitMissionListing.cfm?ID1=#URL.ID1#&ID2=#URL.ID2#','listing')
</script> 
</cfoutput>