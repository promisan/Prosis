
<cfparam name="url.ScheduleId"       	default="00000000-0000-0000-0000-000000000000">
<cfparam name="url.systemfunctionid" 	default="">
<cfparam name="url.selecteddate"     	default="#now()#">
<cfparam name="url.showTarget"     		default="1">
<cfparam name="url.showJump"     		default="1">
<cfparam name="url.showToday"     		default="0">
<cfparam name="url.showPrevious"     	default="1">
<cfparam name="url.mode"    		 	default="edit">

<cfif url.scheduleId eq "">
	<cfset url.scheduleId = "00000000-0000-0000-0000-000000000000">
</cfif>

<cfquery name  = "get" 
    datasource= "AppsWorkOrder" 
    username  = "#SESSION.login#" 
	password  = "#SESSION.dbpw#">      				 
		SELECT   *
		FROM     WorkOrderLineSchedule
		WHERE    ScheduleId = '#url.ScheduleId#'		
</cfquery>

<cfparam name="url.workschedule" 	 	default="#get.WorkSchedule#">

<cfquery name  = "workschedule" 
    datasource= "AppsWorkOrder" 
    username  = "#SESSION.login#" 
	password  = "#SESSION.dbpw#">      				 
		SELECT   *
		FROM     WorkOrderLineScheduleDate
		WHERE    ScheduleId = '#url.ScheduleId#'
		AND      Operational = 1
</cfquery>

<cfquery name  = "validDates" 
   	datasource= "AppsEmployee" 
    username  = "#SESSION.login#" 
	password  = "#SESSION.dbpw#">    
		SELECT DISTINCT	H.CalendarDate
		FROM	WorkScheduleDateHour H
		WHERE	H.WorkSchedule = '#url.WorkSchedule#'
		AND		EXISTS
					(
						SELECT	'X'
						FROM	WorkScheduleOrganization
						WHERE	WorkSchedule = H.WorkSchedule
						AND		OrgUnit IN 
										(
											SELECT 	OrgUnit
											FROM	WorkOrder.dbo.WorkOrderImplementer C
													INNER JOIN WorkOrder.dbo.WorkOrder W
														ON C.WorkOrderId = W.WorkOrderId
													INNER JOIN WorkOrder.dbo.WorkOrderLineSchedule S
														ON W.WorkOrderId = S.WorkOrderId
											WHERE	S.ScheduleId = '#url.ScheduleId#'
										)
					)
</cfquery>

<cfparam name="url.scope" default="backoffice">

<table width="100%" align="center" height="100%">

	 <cfif url.scope eq "Portal">
				
	<tr><td><cfinclude template="ScheduleSummary.cfm"></td></tr>
	
	</cfif>
	
	<tr>
	
		<td width="100%" valign="top">
		
			<table width="100%" cellspacing="0" cellpadding="0" align="center"><tr><td>
			
				<cfset vValidDates = "">
				<cfloop query="validDates">
					<cfset vValidDates = vValidDates & dateFormat(calendarDate,'yyyymmdd') & ','>
				</cfloop>
				<cfif vValidDates neq "">
					<cfset vValidDates = mid(vValidDates, 1, len(vValidDates)-1)>
				</cfif>
				
				<cfset vTarget = "WorkOrder/Application/WorkOrder/ServiceDetails/Schedule/ScheduleDateDetail.cfm">
				<cfif url.showTarget eq 0>
					   <cfset vTarget = "">
				</cfif>
				
				<cf_tl id="Schedule" var="1">
				
				<cfparam name="URL.positionno" default="">
				<cfparam name="URL.personNo"   default="">
				<cfparam name="URL.workschedule"   default="#get.WorkSchedule#">
				
				<cf_calendarView 
				   title          = "#lt_text#"	
				   selecteddate   = "#url.selecteddate#"
				   relativepath   =	"../../.."
				   content        = "WorkOrder/Application/WorkOrder/ServiceDetails/Schedule/ScheduleDate.cfm"
				   target         = "#vTarget#"
				   condition      = "ScheduleId=#url.ScheduleId#&workschedule=#url.WorkSchedule#&systemfunctionid=#url.systemfunctionid#&mode=#url.mode#&personNo=#url.personno#&positionno=#url.positionno#"
				   cellwidth      = "fit"
				   cellheight     = "50"
				   isDisabled	  = "1"
				   validDates	  = "#vValidDates#"
				   showJump	 	  = "#url.showJump#"
				   showToday	  = "#url.showToday#"
				   showPrevious	  = "#url.showPrevious#">			
				   
				   </td></tr>
				   
			   </table>
		
		</td>
	
	</tr>

</table>		   
		