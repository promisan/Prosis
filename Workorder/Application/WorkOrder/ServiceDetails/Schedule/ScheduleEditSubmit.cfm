
<cf_tl id="Operation not allowed, this action has already been defined for these shift and date!" var="mes1">

<cfset dateValue = "">
<CF_DateConvert Value="#form.ScheduleEffective#">
<cfset vDate = dateValue>

<cfparam name="form.WorkOrderLine" default="">
<cfparam name="form.WorkSchedule" default="">

<cfif url.scheduleId eq "">

	<cfset vClean = 1>
	
	<cfif trim(form.WorkSchedule) eq "">
		<cfset vClean = 0>
		<cf_tl id = "Please, select a valid work schedule." var="vMess2">
		<cfoutput>
			<script>
				alert('#vMess2#');				
				Prosis.busy('no')
			</script>
		</cfoutput>
	</cfif>
	
	<cfif vClean eq 1>
	
		<cf_assignId>
	
		<cfquery name="insert" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				INSERT INTO WorkOrderLineSchedule (
							ScheduleId,
							WorkOrderId,
							WorkOrderLine,
							ActionClass,
							ScheduleEffective,
							<cfif form.ScheduleClass neq "">ScheduleClass,</cfif>
							ScheduleName,
							Memo,
							WorkSchedule,
							ActionStatus,
							OfficerUserId,
							OfficerLastName,
							OfficerFirstName )
				VALUES ('#RowGuid#',
						'#url.workorderId#',
						#url.workorderline#,
						'#form.actionClass#',
						#vDate#,
						<cfif form.ScheduleClass neq "">'#Form.ScheduleClass#',</cfif>
						'#Form.ScheduleName#',
						'#Form.Memo#',
						'#Form.WorkSchedule#',
						'#Form.ActionStatus#',
						'#SESSION.acc#',
						'#SESSION.last#',
						'#SESSION.first#' )
		</cfquery>
		
		<cfset url.scheduleid = rowguid>
		
		<cfinclude template="ScheduleCustomSubmit.cfm">
	
		<cfoutput>
			<script>
				ColdFusion.navigate('ScheduleEditContent.cfm?workorderid=#url.workorderid#&workorderline=#url.workorderline#&scheduleId=#rowGuid#', 'editForm');
				try {
				parent.parent.editScheduleRefresh('#url.workorderid#','#url.workorderline#') } catch(e) {}
			</script>
		</cfoutput>
		
	</cfif>

<cfelse>

	<!--- move to the other button

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
					ScheduleClass	  = <cfif form.ScheduleClass neq "">'#Form.ScheduleClass#'<cfelse>null</cfif>
			WHERE	ScheduleId        = '#Form.ScheduleId#'
	</cfquery>
	
	<cfinclude template="ScheduleCustomSubmit.cfm">
	
	<cfif form.workorderline neq "">

	<cfoutput>
		<script>
			ColdFusion.navigate('ScheduleEditContent.cfm?workorderid=#url.workorderid#&workorderline=#form.workorderline#&scheduleId=#form.scheduleId#', 'editForm');					
			try { opener.applyfilter('1','','#form.scheduleid#') } catch(e) { }	
		</script>
	</cfoutput>
	
	<cfelse>
	
	<cfoutput>
		<script>
			ColdFusion.navigate('ScheduleEditContent.cfm?workorderid=#url.workorderid#&workorderline=#url.workorderline#&scheduleId=#form.scheduleId#', 'editForm');				
			try { opener.applyfilter('1','','#form.scheduleid#') } catch(e) { }			
		</script>
	</cfoutput>	
	
	</cfif>
	
	--->

</cfif>