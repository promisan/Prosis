<cfquery name="GetMissions" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	M.*,
				(
					SELECT 	WOSM.Mission
					FROM 	WorkOrder.dbo.WorkOrderServiceMission WOSM
					WHERE	WOSM.ServiceDomain = '#url.id1#'
					AND		WOSM.Reference = '#url.id2#'
					AND		WOSM.Mission = MM.Mission
				) as selected,
				(
					SELECT 	WOSM.OrgUnitImplementer
					FROM 	WorkOrder.dbo.WorkOrderServiceMission WOSM
					WHERE	WOSM.ServiceDomain = '#url.id1#'
					AND		WOSM.Reference = '#url.id2#'
					AND		WOSM.Mission = MM.Mission
				) as OrgUnitImplementer
		FROM   	Ref_MissionModule MM
				INNER JOIN Ref_Mission M
					ON MM.Mission = M.Mission
		WHERE  	MM.SystemModule = 'WorkOrder'
</cfquery>

<table width="95%" align="center" class="navigation_table">
	<cfoutput query="GetMissions">	
		<cfset vChecked = "">
		<cfif selected eq mission>
			<cfset vChecked = "checked">
		</cfif>
		<tr class="navigation_row">
			<td width="1%" style="padding-left:5px; padding-right:10px;"><input type="Checkbox" name="mission_#mission#" id="mission_#mission#" onclick="showOrgUnitMission(this, '#mission#');" #vChecked#></td>
			<td class="labelmedium" width="60%">#Mission#</td>
			<td id="orgunit_#mission#">
				<cfdiv bind="url:workOrderService/setOrgUnit.cfm?mission=#mission#&orgUnit=#orgUnitImplementer#" id="implementer_#mission#">
			</td>
		</tr>
	</cfoutput>
</table>

<cfset AjaxOnLoad("doHighlight")>