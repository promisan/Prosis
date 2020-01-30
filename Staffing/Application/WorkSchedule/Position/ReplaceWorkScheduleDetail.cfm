
<cfset vNewWorkSchedule = url.workSchedule>
<cfif url.workSchedule eq "">
	<cfset vNewWorkSchedule = url.fromWorkSchedule>
</cfif>

<cfquery name="getPosition" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
		SELECT 	*
		FROM 	Position
		WHERE 	PositionNo = '#url.positionno#'

</cfquery>
	
<cfquery name="Tasks" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	S.*,
				D.Description  as DomainClass,
				R.Description  as ActionName, 
				Se.Description AS ServiceDescription,
				( SELECT isActor 
				     FROM   WorkOrderLineSchedulePosition WLSP 
				     WHERE  WLSP.ScheduleId = S.ScheduleId 
					 AND    WLSP.PositionNo = '#url.positionno#' 
					 AND    WLSP.isActor IN ('1','2')) as isActor
	    FROM 	WorkOrderLineSchedule S
				INNER JOIN WorkOrderLine WL
					ON S.WorkOrderId = WL.WorkOrderId
					AND	S.WorkOrderLine = WL.WorkOrderLine
				INNER JOIN WorkOrder W
					ON S.WorkOrderId = W.WorkOrderId
				INNER JOIN WorkOrderService Se
					ON WL.ServiceDomain = Se.ServiceDomain
					AND WL.Reference = Se.Reference
				INNER JOIN Ref_Action R  
					ON S.ActionClass = R.Code 
				LEFT OUTER JOIN Ref_ServiceItemDomainClass D 
					ON WL.ServiceDomain = D.ServiceDomain 
					AND WL.ServiceDomainClass = D.Code 
		WHERE 	S.WorkSchedule = '#url.fromWorkSchedule#'
		AND		S.ActionStatus <> '9'
		AND		EXISTS
				(
					SELECT	'X'
					FROM	WorkOrderLineSchedulePosition
					WHERE	ScheduleId = S.ScheduleId
					AND		PositionNo = '#url.positionNo#'
					AND		Operational = 1
				)
</cfquery>

<cfquery name="Roles" 
	datasource="appsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#"> 
	SELECT    Role
	FROM      Ref_AuthorizationRole
	WHERE     Role = 'WorkOrderProcessor' <!--- SystemModule = 'Workorder'	--->
</cfquery>

<!--- make a list of workorders to which this user has access --->

<cfinvoke  component = "Service.Access"  
    method           = "WorkorderAccessList" 
	mission          = "#getPosition.mission#" 	  
	Role             = "#QuotedvalueList(roles.Role)#"
	returnvariable   = "AccessList">

<table width="100%" cellpadding="0" cellspacing="0" class="navigation_table">

	<tr class="linedotted">
		<td width="5%" class="labelit"></td>
		<td width="2%" class="labelit"></td>
		<td class="labelit"><cf_tl id="Description"></td>
		<td class="labelit"><cf_tl id="Service Area"></td>
		<td class="labelit"><cf_tl id="Class"></td>
		<td class="labelit"><cf_tl id="Action"></td>
		<td class="labelit"><cf_tl id="Actor Type"></td>
		<td width="15%" class="labelit" align="right"><cf_tl id="Status"></td>
	</tr>
		
	<tr><td height="5"></td></tr>
	
	<cfif Tasks.recordCount eq 0>
		<tr>
			<td class="labelit" colspan="8" align="center" style="color:red;"><cf_tl id="No tasks assigned to this position in this work schedule."></td>
		</tr>
	</cfif>
	<cfoutput query="Tasks">
		<cfquery name="ValidateTasks" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT  *
               	FROM    WorkOrderLineScheduleDate D
                WHERE   ScheduleId = '#ScheduleId#'
				AND		ScheduleDate > getDate()
				AND		Operational = 1
				AND 	NOT EXISTS
						(
							SELECT 	'X'
							FROM	Employee.dbo.WorkScheduleDateHour EDH
							WHERE	WorkSchedule = '#vNewWorkSchedule#'
							AND		EDH.CalendarDate = D.ScheduleDate
							AND		(
										D.ScheduleHour = EDH.CalendarHour
										OR
										D.ScheduleHour = (EDH.CalendarHour + (SELECT HourMode/60.0 FROM Employee.dbo.WorkSchedule WHERE Code = '#WorkSchedule#'))
										OR
										D.ScheduleHour = -1
									)
						)
		</cfquery>
		
		<cfset vRowColor = "">
		<cfif ValidateTasks.recordCount gt 0>
			<cfset vRowColor = "FFC1C2;">
		</cfif>
		
		<tr style="height:20px; background-color:#vRowColor#" class="navigation_row labelit">
			<td>
				<cfif url.workSchedule neq "">
					<cfset vIdScheduleId = replace(ScheduleId,"-","","ALL")>
					<input type="Checkbox" name="cb_#vIdScheduleId#" id="cb_#vIdScheduleId#" checked>
				</cfif>
			</td>
			<td>
				<cfset vMode = "readonly">
					
				<cfif Find(workOrderId,preserveSingleQuotes(AccessList))>
					<cfset vMode = "edit">
				</cfif>
				
				<cf_img navigation="yes" icon="edit" onclick="editWorkOrderLineSchedule('#ScheduleId#','#vMode#');">
			</td>
			<td>#memo#</td>
			<td>#ServiceDescription#</td>
			<td>#DomainClass#</td>
			<td>#ActionName#</td>
			<td>
				<cfif isActor eq 1>
					<cf_tl id="Assistant">
				</cfif>
				<cfif isActor eq 2>
					<cf_tl id="Responsible">
				</cfif>
			</td>
			<td width="15%" align="right">
				<cfif ValidateTasks.recordCount gt 0>
					<span style="color:red;"><cf_tl id="[Hour mismatches]"></span>
				<cfelse>
					<span style="color:green;"><cf_tl id="OK"></span>
				</cfif>
			</td>
		</tr>
	</cfoutput>
</table>

<cfset AjaxOnLoad("doHighlight")>
