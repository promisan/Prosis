<!--- saving and refreshing the calendar --->

<cfparam name="Form.selected" 		default="">
<cfparam name="Form.hours"    		default="">
<cfparam name="url.action"    		default="add">
<cfparam name="url.refreshDetail"   default="1">

<cfset dateValue = "">
<CF_DateConvert Value="#form.ScheduleEffective#">
<cfset vDate = dateValue>

<cfparam name="form.WorkOrderLine" default="">

<cftransaction>
		
	<cfquery name="update" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE 	WorkOrderLineSchedule
			SET		ScheduleEffective = #vDate#,
			        <cfif form.workorderline neq "">
					WorkOrderLine     = '#form.workorderline#',
					</cfif>
					Memo              = '#Form.Memo#',
					ScheduleName      = '#Form.ScheduleName#', 
					ActionStatus      = '#Form.ActionStatus#',
					WorkSchedule      = '#Form.WorkSchedule#',
					ScheduleClass	  = <cfif isDefined("form.ScheduleClass") AND form.ScheduleClass neq "">'#Form.ScheduleClass#'<cfelse>null</cfif>
			WHERE	ScheduleId        = '#Form.ScheduleId#'
	</cfquery>
	
	<cfquery name  = "schedule" 
	   	datasource= "AppsWorkOrder" 
	    username  = "#SESSION.login#" 
		password  = "#SESSION.dbpw#">    
		SELECT  *
		FROM   	WorkOrderLineSchedule
	    WHERE   ScheduleId = '#url.ScheduleId#'					  		
	</cfquery>
	
	<cfparam name="url.workorderid"   default="#schedule.workorderid#">
	<cfparam name="url.workorderline" default="#schedule.workorderline#">		
	
	<cfinclude template="ScheduleCustomSubmit.cfm">
	
	<cfquery name  = "getWorkSchedule" 
	   	datasource= "AppsWorkOrder" 
	    username  = "#SESSION.login#" 
		password  = "#SESSION.dbpw#">    
		SELECT  *
		FROM   	Employee.dbo.WorkSchedule
	    WHERE   Code = '#schedule.workSchedule#'		  		
	</cfquery>

	<cfquery name  = "clearHours" 
	   	datasource= "AppsWorkOrder" 
	    username  = "#SESSION.login#" 
		password  = "#SESSION.dbpw#">    
		DELETE 
		FROM   	WorkOrderLineScheduleDate
	    WHERE   ScheduleId = '#url.ScheduleId#'					  
		AND     ScheduleDate = #url.selecteddate#
		AND     Operational = 1
	</cfquery>
	
	<cfif url.action eq "add">
	
		<cfquery name  = "checkValid" 
	    	datasource= "AppsWorkOrder" 
		    username  = "#SESSION.login#" 
			password  = "#SESSION.dbpw#">    
				SELECT 	H.*
				FROM	Employee.dbo.WorkScheduleDateHour H
				WHERE	H.WorkSchedule = '#schedule.workSchedule#'
				AND		H.CalendarDate = #url.selecteddate#
				AND		EXISTS
							(
								SELECT	'X'
								FROM	Employee.dbo.WorkScheduleOrganization
								WHERE	WorkSchedule = H.WorkSchedule
								AND		OrgUnit IN  
												(
													SELECT  OrgUnit
													FROM	WorkOrder.dbo.WorkorderImplementer
												    WHERE   WorkOrderId = '#schedule.workorderid#' 
												)
							)
				ORDER BY CalendarHour ASC
		</cfquery>
		
		<cfif isDefined("Form.Hour_AnyTime")>
			
			<cfif checkValid.recordCount gt 0>
				<cfset vMemo = evaluate("Form.Memo_AnyTime")>
				
				<cfquery name  = "add" 
			    	datasource= "AppsWorkOrder" 
				    username  = "#SESSION.login#" 
					password  = "#SESSION.dbpw#">    
					INSERT INTO WorkOrderLineScheduleDate (
							ScheduleId,
							ScheduleDate,
							ScheduleHour,
							Memo,
							Source,
							OfficerUserId,
							OfficerLastName,
							OfficerFirstName )
					VALUES ('#url.ScheduleId#',
							#url.selecteddate#,
							-1,
							'#vMemo#',
							'Manual',
							'#SESSION.acc#',
							'#SESSION.last#',
							'#SESSION.first#' )		
				</cfquery>
			</cfif>
		
		<cfelse>
		
			<cfloop query="checkValid" endrow="1">
			
				<cfset vCalendarHour = CalendarHour>
				
				<cfif isDefined("Form.Hour_#replace(vCalendarHour,'.','_','ALL')#")>
					<cfset vMemo = evaluate("Form.Memo_#replace(vCalendarHour,'.','_','ALL')#")>
					
					<cfquery name  = "add" 
				    	datasource= "AppsWorkOrder" 
					    username  = "#SESSION.login#" 
						password  = "#SESSION.dbpw#">    
						INSERT INTO WorkOrderLineScheduleDate (
								ScheduleId,
								ScheduleDate,
								ScheduleHour,
								Memo,
								Source,
								OfficerUserId,
								OfficerLastName,
								OfficerFirstName )
						VALUES ('#url.ScheduleId#',
								#url.selecteddate#,
								'#vCalendarHour#',
								'#vMemo#',
								'Manual',
								'#SESSION.acc#',
								'#SESSION.last#',
								'#SESSION.first#' )		
					</cfquery>	
					
				</cfif>
				
			</cfloop>
			
			<cfloop query="checkValid">
			
				<cfset vCalendarHour = CalendarHour + (getWorkSchedule.HourMode/60)>
				
				<cfif isDefined("Form.Hour_#replace(vCalendarHour,'.','_','ALL')#")>
					<cfset vMemo = evaluate("Form.Memo_#replace(vCalendarHour,'.','_','ALL')#")>
					
					<cfquery name  = "add" 
				    	datasource= "AppsWorkOrder" 
					    username  = "#SESSION.login#" 
						password  = "#SESSION.dbpw#">    
						INSERT INTO WorkOrderLineScheduleDate (
								ScheduleId,
								ScheduleDate,
								ScheduleHour,
								Memo,
								Source,
								OfficerUserId,
								OfficerLastName,
								OfficerFirstName )
						VALUES ('#url.ScheduleId#',
								#url.selecteddate#,
								'#vCalendarHour#',
								'#vMemo#',
								'Manual',
								'#SESSION.acc#',
								'#SESSION.last#',
								'#SESSION.first#' )		
					</cfquery>	
					
				</cfif>
				
			</cfloop>
			
		</cfif>

	</cfif>

</cftransaction>

<cfif url.refreshDetail eq 1>

	<cfoutput>
		<script>
			ColdFusion.navigate('ScheduleSummary.cfm?scheduleid=#url.scheduleid#','summarybox');
			calendarrefresh('#day(url.selecteddate)#','#urlencodedformat(url.selecteddate)#');
			ColdFusion.navigate('ScheduleEditExpiration.cfm?scheduleid=#url.scheduleid#','expirationbox');
			try { if ($('###url.scheduleid#').length > 0) { opener.applyfilter('1','','#url.scheduleid#'); } } catch(e) { }							
			Prosis.busy('No');
		</script>
	</cfoutput>
	
	<cfinclude template="ScheduleDateDetail.cfm">
</cfif>

 