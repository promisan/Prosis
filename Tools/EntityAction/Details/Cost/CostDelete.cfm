
<cfquery name="Check" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM   OrganizationObjectActionCost
		WHERE  ObjectCostId  = '#URL.ObjectCostId#'				
</cfquery>

<cfoutput>
<script>
	ProsisUI.closeWindow('costdialog')		
	ColdFusion.navigate('#SESSION.root#/tools/entityaction/details/cost/CostList.cfm?box=#url.box#&mode=#url.Mode#&objectid=#URL.ObjectId#&actioncode=#url.actionCode#','#url.box#') 							
</script>	
</cfoutput>		


	
