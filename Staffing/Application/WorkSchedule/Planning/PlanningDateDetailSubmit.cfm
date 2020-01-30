<!--- saving and refreshing the calendar --->

<cfparam name="Form.selected" default="">
<cfparam name="Form.hours"    default="">
<cfparam name="url.action"    default="add">
<cfparam name="url.mission"   default="">
<cfparam name="url.mandate"   default="">

<cftransaction>

	<cfquery name  = "getDate" 
    	datasource = "AppsEmployee" 
	    username   = "#SESSION.login#" 
		password   = "#SESSION.dbpw#">    
		SELECT 	* 
		FROM   	WorkScheduleDate
	    WHERE   WorkSchedule = '#url.workschedule#'					  
		AND     CalendarDate = #url.selecteddate#
	</cfquery>
	
	<cfif getDate.recordcount eq "0">
	
		<cfquery name  = "add" 
	    	datasource= "AppsEmployee" 
		    username  = "#SESSION.login#" 
			password  = "#SESSION.dbpw#">    
			INSERT INTO WorkScheduleDate
				(WorkSchedule,
				 CalendarDate,		
				 OfficerUserId,
				 OfficerLastName,
				 OfficerFirstName)
			VALUES
				('#url.workschedule#',
				 #url.selecteddate#,		
				 '#session.acc#',
				 '#session.last#',
				 '#session.first#')			
		</cfquery>	
	
	</cfif>
	
	<cfquery name  = "clearHours" 
    	datasource= "AppsEmployee" 
	    username  = "#SESSION.login#" 
		password  = "#SESSION.dbpw#">    
		DELETE FROM  WorkScheduleDateHour
	    WHERE        WorkSchedule = '#url.workschedule#'					  
		AND          CalendarDate = #url.selecteddate#
	</cfquery>
	
	<cfquery name  = "clearPosition" 
    	datasource= "AppsEmployee" 
	    username  = "#SESSION.login#" 
		password  = "#SESSION.dbpw#">    
		DELETE FROM  WorkSchedulePosition
	    WHERE        WorkSchedule = '#url.workschedule#'					  
		AND          CalendarDate = #url.selecteddate#
	</cfquery>
	
	<cfif form.hours neq "">
		
		<cfloop index="hr" list="#form.hours#">
		
			<cfset fieldid = round(hr * 4)>
			<cfparam name="form.ActionClass_#fieldid#" default="">
			<cfset cls = evaluate("form.ActionClass_#fieldid#")>	
					
			<cfquery name  = "add" 
		    	datasource= "AppsEmployee" 
			    username  = "#SESSION.login#" 
				password  = "#SESSION.dbpw#">    
				INSERT INTO WorkScheduleDateHour
				       (WorkSchedule,CalendarDate,CalendarHour,ActionClass)
				VALUES ('#url.workschedule#',#url.selecteddate#,'#hr#',<cfif cls eq "">NULL<cfelse>'#cls#'</cfif>)		
			</cfquery>	
	
		</cfloop>
		
		<!--- adding positions --->
	
		<cfif form.selected neq "">
			
			<cfset vPosList = replace(Form.Selected,"'","","ALL")>
			<cfloop index="pos" list="#vPosList#">

				<cfset vPointerBreak = 0>
				<cfif isDefined("Form.pointerBreak_#pos#")>
					<cfif evaluate("Form.pointerBreak_#pos#") neq "-">
						<cfset vPBreakList = replace(evaluate("Form.pointerBreak_#pos#"),"'","","ALL")>
						<cfset cnt = 1>
						<cfloop index="pbreak" list="#vPBreakList#">
							<cfif cnt eq 1>
								<cfif pbreak neq "-">
									<cfset vPointerBreak = pbreak>
								</cfif>
							</cfif>
							<cfset cnt = cnt + 1>
						</cfloop>
					</cfif>
				</cfif>
				
				<cfquery name  = "validate" 
			    	datasource= "AppsEmployee" 
				    username  = "#SESSION.login#" 
					password  = "#SESSION.dbpw#">
					
						SELECT 	*
						FROM	WorkSchedulePosition
						WHERE	WorkSchedule = '#url.workschedule#'
						AND		CalendarDate = #url.selecteddate#
						AND		PositionNo = #pos#
					
				</cfquery>
				
				<cfif validate.recordCount eq 0>
				
					<cfquery name  = "validatePos" 
			    		datasource= "AppsEmployee" 
					    username  = "#SESSION.login#" 
						password  = "#SESSION.dbpw#">
							SELECT 	*
							FROM	Position
							WHERE	PositionNo = '#pos#'
							AND		#url.selecteddate# BETWEEN DateEffective AND DateExpiration
					</cfquery>
					
					<cfif validatePos.recordCount gt 0>
					
						<cfquery name  = "add" 
					    	datasource= "AppsEmployee" 
						    username  = "#SESSION.login#" 
							password  = "#SESSION.dbpw#">    
							INSERT  INTO WorkSchedulePosition
								    (WorkSchedule,CalendarDate,PositionNo,<cfif vPointerBreak neq 0>PointerBreak,</cfif>OfficerUserId,OfficerLastName,OfficerFirstName)
							VALUES  ('#url.workschedule#',#url.selecteddate#,#pos#,<cfif vPointerBreak neq 0>'#vPointerBreak#',</cfif>'#session.acc#','#session.last#','#session.first#')
						</cfquery>	
					
					</cfif>
				</cfif>
				
			</cfloop>	
		
		</cfif>
		
	<cfelse>
	
		<cfquery name  = "clearDate" 
	    	datasource= "AppsEmployee" 
		    username  = "#SESSION.login#" 
			password  = "#SESSION.dbpw#">    
			DELETE FROM   WorkScheduleDate
		    WHERE         WorkSchedule = '#url.workschedule#'					  
			AND           CalendarDate = #url.selecteddate#
		</cfquery>
					
	</cfif>
	
	<cfif url.action eq "inherit">
		<cfinclude template="PlanningDateDetailSubmitInherit.cfm">
	</cfif>

</cftransaction>

<cfinclude template="PlanningDateDetail.cfm">

<!--- refreshing --->
<cfloop index="d" from="1" to="#daysInMonth(url.selectedDate)#">
	<cfset vDate = createDate(year(url.selectedDate),month(url.selectedDate),d)>
	<cfoutput>
		<script>
		    _cf_loadingtexthtml="";	
			calendarrefreshonly('#d#','#urlencodedformat(vDate)#');
		</script>
	</cfoutput>
</cfloop>

<cfoutput>
	<script>
		try {
			ColdFusion.Window.destroy('inheritSchedule');
		}catch(e){}
	</script>
</cfoutput>


 