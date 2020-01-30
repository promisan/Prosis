
<table width="100%" height="100%" cellspacing="0" cellpadding="0" class="formpadding">

	<tr><td height="10"></td></tr>	
	<tr><td style="height:20" class="labelmedium"><b>Indirect or direct support for service orders</td></tr>
	<tr><td class="linedotted"></td></tr>
	
	<tr><td style="padding-left:30px">		
		<cfinclude template="WorkScheduleSupport.cfm">
	</td></tr>
	
	<tr><td height="10"></td></tr>	
	
	<tr><td style="height:20" class="labelmedium">
	
		<table>
		
		<cfoutput>
		
		<tr>
			<td>
			<input type="radio" name="Actions" value="current" style="width:20;height:20" checked 
			   onclick="ColdFusion.navigate('#session.root#/Staffing/Application/Position/ScheduledTask/WorkScheduleListingAction.cfm?mode=assigned&positionno=#url.positionno#','listingbox')">
			</td>
			<td style="padding-left:10px" class="labellarge">Assigned to this position</td>
			<td style="padding-left:10px"><td>
			<input type="radio" name="Actions" value="current" style="width:20;height:20" 
			   onclick="ColdFusion.navigate('#session.root#/Staffing/Application/Position/ScheduledTask/WorkScheduleListingAction.cfm?mode=action&positionno=#url.positionno#','listingbox')">
			</td>
			<td  style="padding-left:10px" class="labellarge">All potential tasks for the orgunit of this position and its assigned workschedule</td>
		</tr>
		
		</cfoutput>
		
		</table>
	
	</td>
	</tr>
			
	<tr><td class="linedotted"></td></tr>
		
	<!--- for inconsistency added the view to detect assignments for schedules that are no longer enabled --->
	
	<cfquery name="getMissing" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
		FROM   WorkOrder.dbo.WorkOrderLineSchedulePosition WP, 
		       WorkOrder.dbo.WorkOrderLineSchedule W
		WHERE  WP.ScheduleId = W.ScheduleId 
		AND    WP.PositionNo = '#URL.PositionNo#'
		AND    WP.isActor IN ('1','2')
		AND	   W.ActionStatus <> '9'
		AND    W.WorkSchedule NOT IN ( SELECT  DISTINCT WorkSchedule 
									   FROM    WorkSchedulePosition
									   WHERE   CalendarDate >= getDate()
									   AND     PositionNo = '#URL.PositionNo#' 
									 )
	</cfquery>	
		
	<cfif getMissing.recordcount gte "1">
	
		<tr><td align="center" style="height:30" class="Labelmedium"><font color="FF0000"><b>Attention</b> : Position is assigned to a one or more scheduled activities with a workschedule it is not enabled for.</font></td></tr>
		<tr><td class="linedotted"></td></tr>
		
	</cfif>	
	
	<tr><td></td></tr>	
	<tr><td height="100%" id="listingbox">
		<cfinclude template="WorkScheduleListingAction.cfm">
	</td></tr>

</table>

