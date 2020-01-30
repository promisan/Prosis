<cfquery name="get" 
	datasource="appsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	* 
		FROM 	WorkOrder
		WHERE 	WorkOrderId = '#url.workOrderId#'				
</cfquery>	

<cfquery name="mandateList" 
	datasource="appsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT	*
		FROM	Ref_Mandate
		WHERE 	Mission = '#get.mission#'
		AND		Operational = 1
		ORDER BY DateExpiration		
</cfquery>	

<table>

	<cfoutput query="mandateList">
		<tr>
			<td class="labelmedium">#MandateNo# - #Description#</td>
			<td class="labelit" style="padding-left:3px;padding-right:3px;">(#dateFormat(DateEffective,client.dateFormatShow)# - #dateFormat(DateExpiration,client.dateFormatShow)#)</td>
			
			<td class="labelit" style="padding-left:3px;color:808080;">
				<cfquery name="total" 
					datasource="appsWorkOrder" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT 	I.* 
						FROM 	WorkOrderImplementer I
						WHERE 	I.WorkOrderId = '#url.workOrderId#'
						AND		EXISTS
								(
									SELECT 	'X'
									FROM	Organization.dbo.Organization
									WHERE	MandateNo = '#MandateNo#'
									AND		OrgUnit = I.OrgUnit
								)		
				</cfquery>
				( <cf_tl id="No of units implementing">: <b>#total.RecordCount#</b> )
			</td>
			
			<td style="padding-left:3px;">
			
			   <cf_img icon="add" tooltip="Add" onclick="addImplementerOrgUnit('#get.mission#','#mandateNo#','#url.workOrderId#');">
			   			   
				<cf_tl id="Add OrgUnits" var="1">
								
			</td>
		</tr>
	</cfoutput>
</table>