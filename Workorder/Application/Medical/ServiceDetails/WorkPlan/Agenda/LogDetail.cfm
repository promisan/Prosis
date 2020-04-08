<cfquery name="LogDetail" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT  PlanOrder,
		   		PlanOrderCode,
			   	WorkActionId,
				WorkSchedule,
				(SELECT LocationName
				FROM   Location
				WHERE  LocationId = D.LocationId) as LocationName,				
				DateTimePlanning,
				OrgUnitOwner,
				Operational,
				OfficerUserId,
				OfficerLastName,
				OfficerFirstName,
				Created
		FROM 	WorkPlanDetail D WITH (NOLOCK)
		WHERE   WorkActionId = '#url.workactionid#'
		ORDER BY Created DESC
</cfquery>

<table width="100%" class="navigation_table">
	<tr class="labelit"><td class="line" colspan="5"><b><cf_tl id="Previously scheduled for">:</td></tr>
	<cfoutput query="LogDetail">
		<cfset vColor = "">
		<cfif operational eq 1>
			<cfset vColor = "##8AFF93">	
		</cfif>
		<tr style="border-top:1px solid silver;height:16px" class="navigation_row labelit">
			<td style="min-width:10px;" bgcolor="#vColor#"></td>
			<td style="min-width:20px;padding-right:2px; padding-left:2px;">#currentrow#</td>
			<td style="min-width:40px;padding-right:2px; padding-left:2px;">#PlanOrderCode#</td>
			<td style="min-width:70px;padding-right:2px; padding-left:2px;">#LocationName#</td>
			<td style="min-width:90px">				
				#dateformat(DateTimePlanning, client.DateFormatShow)# 
				<cfset vDayName = lsdateformat(DateTimePlanning, 'ddd')>
				<cf_tl id="#left(vDayName,1)#">
			</td>
			<td style="min-width:70px">#timeformat(DateTimePlanning,'hh:mm-tt')#</td>
			<td style="width:60%;padding-right:2px; padding-left:2px;">#officerlastname#</td>
		</tr>
	</cfoutput>
</table>

<cfset ajaxOnLoad("doHighlight")>
