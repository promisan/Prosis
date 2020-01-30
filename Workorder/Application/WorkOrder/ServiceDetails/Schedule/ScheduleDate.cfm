
<cfquery name="get" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  WLSD.*, 
		        W.Mission AS Mission, 
				W.CustomerId AS CustomerId,
				WLS.WorkSchedule
		FROM    WorkOrderLineScheduleDate WLSD INNER JOIN
	            WorkOrderLineSchedule WLS ON WLSD.ScheduleId = WLS.ScheduleId INNER JOIN
	            WorkOrderLine WL ON WLS.WorkOrderId = WL.WorkOrderId AND WLS.WorkOrderLine = WL.WorkOrderLine INNER JOIN
	            WorkOrder W ON WL.WorkOrderId = W.WorkOrderId
		WHERE  	WLSD.ScheduleId   = '#url.ScheduleId#'					  
		AND     WLSD.ScheduleDate =  #url.calendardate# 	
		AND     WLSD.Operational = 1	 
</cfquery>

<cfquery name="getSchedule" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     WorkSchedule
		WHERE    Code    = '#url.workschedule#' 		 
</cfquery>

<cfset str = url.calendardate>
<cfset end = dateAdd("d",1,str)>

<cfif get.recordcount gte "1">

		<cfset show = "1">
							
		<cfif PersonNo eq "">
		
			<cfparam name="Assignment.AssignmentDateExpiration" default="">
					
		<cfelse>			
							
			<!--- check if the person is serving on the selected date in the mission --->
														
			<cfquery name="Assignment" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT     TOP 1 PA.DateExpiration AS AssignmentDateExpiration,  PA.DateEffective AS AssignmentDateEffective
				FROM       PersonAssignment PA INNER JOIN
		                   Position ON PA.PositionNo = Position.PositionNo
				WHERE      PA.PersonNo         = '#PersonNo#' 
				AND        Position.PositionNo = '#PositionNo#' 
				AND        PA.AssignmentStatus IN ('0', '1') 
				AND        PA.Incumbency     > 0 
				AND        PA.DateEffective <= #str#
				AND        Position.Mission = '#get.Mission#'		
				ORDER BY   PA.DateExpiration DESC
			</cfquery>
			
			<cfif Assignment.AssignmentDateExpiration eq "" or 
		 	   (Assignment.AssignmentDateExpiration lt url.calendardate or Assignment.AssignmentDateEffective gt url.calendardate)>	
		
				<!--- person has left in this month --->	
							
				<table width="100%" height="100%" cellspacing="0" cellpadding="0" bgcolor="FAE7AB" style="border:1px solid silver">
					<tr>
				 	  	<td valign="top" align="center" class="labelit" style="padding-top:3px;padding-left:5px;"><cf_tl id="N/A"></td>
					</tr>
				</table>	
				
				<cfset show = "0">
			
			</cfif>	
												
		</cfif>		
				
		<cfif show eq "1">					
		
		<cfif str gt now()>
		
			<cfset color = "74A8F5">
		<cfelse>
		
			<cfset color = "silver">
		</cfif>
										
		<table width="100%" height="100%" cellspacing="0" cellpadding="0" bgcolor="<cfoutput>#color#</cfoutput>" style="border:0px solid silver">
		   
			<tr>
		 	  	<td valign="top" class="labelit" style="padding:2px;">
												
					<cfif dateDiff('d', now(), url.calendarDate) gte 0>
											
						<!---future and now--->
						<cfoutput>
							<cfsavecontent variable="scheduleQuery">    	
								SELECT  D.ScheduleHour,
										D.Memo,
										ISNULL((
											SELECT	COUNT(*)
											FROM	Employee.dbo.WorkScheduleDateHour
											WHERE	WorkSchedule = '#url.workschedule#'
											AND		CalendarDate = D.ScheduleDate
											AND		(
														CalendarHour = D.ScheduleHour
														OR
														D.ScheduleHour = (CalendarHour + (SELECT HourMode/60.0 FROM Employee.dbo.WorkSchedule WHERE Code = '#url.workschedule#'))
														OR
														D.ScheduleHour = -1
													)
										),0) as ValidHour
								FROM    WorkOrderLineScheduleDate D	INNER JOIN WorkOrderLineSchedule S ON D.ScheduleId = S.ScheduleId
								WHERE  	D.ScheduleId   = '#url.ScheduleId#'					  
								AND     D.Operational = 1
								AND     D.ScheduleDate =  #url.calendardate#
								ORDER BY D.ScheduleHour ASC
							</cfsavecontent>
						</cfoutput>
					<cfelse>
					
						<!---past--->
						
						<cfoutput>
							<cfsavecontent variable="scheduleQuery">    	
								SELECT	(DATEPART(hour, DateTimePlanning) + (CONVERT(FLOAT, DATEPART(minute, DateTimePlanning)) / 60.0)) ScheduleHour,
										'' as Memo,  <!--- removed memo hanno --->
										1 as ValidHour
								FROM	WorkOrderLineAction
								WHERE	ScheduleId              = '#url.ScheduleId#'
								AND		YEAR(DateTimePlanning)  = '#year(url.calendardate)#'
								AND		MONTH(DateTimePlanning) = '#month(url.calendardate)#'
								AND		DAY(DateTimePlanning)   = '#day(url.calendardate)#'
								ORDER BY DateTimePlanning ASC		  
							</cfsavecontent>
						</cfoutput>
						
					</cfif>												
											
					<cfquery name="qScheduleHours" 
						datasource="appsWorkOrder" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						    #preserveSingleQuotes(scheduleQuery)#
					</cfquery>
					
					<table cellspacing="0" cellpadding="0">
										
					<cfoutput query="qScheduleHours">
					
						<cfset vLabelColor = "FFFFFF">
						<cfset vLabelMsg = "">
						<cfif ValidHour eq 0>
							<cfset vLabelColor = "FB3833">
							<cf_tl id="This hour is not valid anymore, please check the staffing definition." var="1">
							<cfset vLabelMsg = lt_text>
						</cfif>
					
						<cfif schedulehour lt 0>
						<tr><td style="padding-left:3px; color:#vLabelColor#;" class="labelit" title="#vLabelMsg#">Any time</td></tr>
						<cfelse>
						<tr><td style="padding-left:3px; color:#vLabelColor#;" class="labelit" title="#vLabelMsg#">							
						<cf_ConvertDecimalToHour DecimalHour = "#ScheduleHour#">
						<cfif ValidHour eq 0>** </cfif>#StringHour#					
						</td>
						<td style="padding-left:3px; color:#vLabelColor#;" class="labelit" title="#vLabelMsg#">#Memo#</td>
						</tr>	
						</cfif>					
						
					</cfoutput>
					</table>
					
				</td>
			</tr>
		</table>

	</cfif>	
			
</cfif>