<cfquery name="LogDetail" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT  PlanOrder,
		   		PlanOrderCode,
			   	WorkActionId,
				WorkSchedule,
				DateTimePlanning,
				OrgUnitOwner,
				Operational,
				OfficerUserId,
				OfficerLastName,
				OfficerFirstName,
				Created
		FROM 	WorkPlanDetail WITH (NOLOCK)
		WHERE   WorkActionId = '#url.workactionid#'
		ORDER BY Created DESC
</cfquery>

<table width="100%" class="navigation_table">
	<tr class="line"><td colspan="3" class="labelit"><cf_tl id="Previously scheduled for">:</td></tr>
	<cfoutput query="LogDetail">
		<cfset vColor = "">
		<cfif operational eq 1>
			<cfset vColor = "##8AFF93">	
		</cfif>
		<tr class="navigation_row">
			<td style="width:30px;" bgcolor="#vColor#"></td>
			<td width="1%" style="padding-right:5px; padding-left:5px;">#currentrow#.</td>
			<td class="labelit">
				<cfset vDayName = dateformat(DateTimePlanning, 'dddd')>
				<cf_tl id="#vDayName#"> #dateformat(DateTimePlanning, client.DateFormatShow)# @ #timeformat(DateTimePlanning, 'hh:mm tt')# [#officerlastname#]
			</td>
		</tr>
	</cfoutput>
</table>

<cfset ajaxOnLoad("doHighlight")>
