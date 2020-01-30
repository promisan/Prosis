<cfparam name="url.action" default="update">

<cfif url.action eq "delete">
		
	<cfquery name="Schedule" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT * FROM Schedule
		WHERE  ScheduleId = '#url.id#' 
	</cfquery>
	
	<cftry>
	
	<cfschedule action="DELETE" task="#Schedule.ScheduleName#">
	
	<cfcatch></cfcatch>
	
	</cftry>
	
	<cfquery name="Delete" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		DELETE FROM Schedule
		WHERE   ScheduleId = '#url.id#' 
	</cfquery>
	
	<cfoutput>
		<script>			
			document.getElementById("lin#URL.id#").className = "hide"	
			document.getElementById("log#URL.id#").className = "hide"
		</script>
	</cfoutput>
	
<cfelse>
		
	<!--- Query returning search results --->
	<cfquery name="Schedule"
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
		FROM   Schedule S
		WHERE  ScheduleId = '#URL.ID#'
	</cfquery>
		
	<cfschedule  
    action = "list" 
    mode = "server"
    result = "CFScheduleList">
		
	<cfquery name="System" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM    Parameter
	</cfquery>
	
	<cftry>
	
		<cfquery name="Parameter" 
				datasource="AppsInit">
				SELECT *
				FROM   Parameter 
				WHERE  HostName = '#CGI.HTTP_HOST#'
				AND    ApplicationServer IN (SELECT ApplicationServer 
				                             FROM   [#System.ControlServer#].Control.dbo.ParameterSite)
		</cfquery>
		
	<cfcatch>
	
		<cfquery name="Parameter" 
				datasource="AppsInit">
				SELECT *
				FROM   Parameter 
				WHERE  HostName = '#CGI.HTTP_HOST#'			
		</cfquery>
	
	
	</cfcatch>
	
	</cftry>
	
	<cfparam name="op" default="#schedule.operational#">
	
	<cfoutput query="schedule">
	
	    <cfif op eq 0 or ScheduleInterval eq "Manual">
		
			<cftry>
		
			<cfschedule action="DELETE" task="#Schedule.ScheduleName#">
			
			<cfcatch></cfcatch>
			
			</cftry>
		
		<cfelse>		
				
			<!--- Cleans up schedule tasks that have the same name but belong to different group --->	
			<cfloop query="CFScheduleList">
			
				<cfif Task eq schedule.ScheduleName and Group neq schedule.SystemModule>
					
					<cftry>
						<cfschedule action="DELETE" task="#Task#">
					<cfcatch></cfcatch>	
					</cftry>
					
					<cfbreak>
					
				</cfif>
				
			</cfloop>
				
			<cfif Schedule.SchedulePassThru neq "">
				<cfset passtru = "&#Schedule.SchedulePassThru#">
			<cfelse>
			    <cfset passtru = "">
			</cfif>						
		
			<cfif Schedule.ParentScheduleId eq "">
		
				<!--- Re-build the list of tasks chained to this task --->
					   
				<cfquery name="ChainedTasks" 
					datasource="AppsSystem" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">		

						SELECT ScheduleName + ':' +SystemModule AS Task
						FROM   Schedule
						WHERE  ParentScheduleId = '#Schedule.ScheduleId#'
					
				</cfquery> 
				 
				<cfset taskList = ValueList(ChainedTasks.Task,",")>
				 
				<cfif Schedule.SchedulePassThru neq "">
					<cfset passtru = "&#Schedule.SchedulePassThru#">
				<cfelse>
				    <cfset passtru = "">
				</cfif>
		
				<cfif Schedule.ScheduleEndTime eq "">
					
					<cfschedule action = "update"
					   task            = "#Schedule.ScheduleName#" 
					   operation       = "HTTPRequest"
					   url             = "#SESSION.root#/tools/scheduler/RunScheduler.cfm?id=#Schedule.ScheduleName##passtru#"
					   startDate       = "#dateFormat(Schedule.ScheduleStartDate,client.DateSQL)#"
					   startTime       = "#Schedule.ScheduleStartTime#"					   
					   interval        = "#Schedule.ScheduleInterval#"
					   group           = "#Schedule.SystemModule#" 
					   resolveURL      = "Yes"
					   publish         = "Yes"
					   file            = "#Schedule.ScheduleName#.txt"
					   path            = "#parameter.schedulerroot#"
					   onmisfire	   = "#Schedule.ScriptMisfire#"					   
   					   oncomplete	   = "#taskList#">
					   
					   <!--- requestTimeOut  = "#Schedule.ScriptTimeOut#" --->
				   
				<cfelse>
				  
				  	<cfschedule action = "update"
					   task            = "#Schedule.ScheduleName#" 
					   operation       = "HTTPRequest"
					   url             = "#SESSION.root#/tools/scheduler/RunScheduler.cfm?id=#Schedule.ScheduleName##passtru#"
					   startDate       = "#dateFormat(Schedule.ScheduleStartDate,client.DateSQL)#"
					   startTime       = "#Schedule.ScheduleStartTime#"
					   endDate         = "#dateFormat(Schedule.ScheduleEndDate,client.DateSQL)#"
					   endTime         = "#Schedule.ScheduleEndTime#"
					   group           = "#Schedule.SystemModule#" 
					   interval        = "#Schedule.ScheduleInterval#"
					   resolveURL      = "Yes"
					   publish         = "Yes"
					   file            = "#Schedule.ScheduleName#.txt"
					   path            = "#parameter.schedulerroot#"
					   onmisfire	   = "#Schedule.ScriptMisfire#"					   
					   oncomplete	   = "#taskList#">
				  	  
					  <!--- requestTimeOut  = "#Schedule.ScriptTimeOut#" --->
					  
				</cfif> 
			
			<cfelse> 	<!--- It means that this is a chained task, therefore, no Interval, StartDate and StartTime is to be passed--->

				<cfschedule action = "update"
					   task            = "#Schedule.ScheduleName#" 
					   operation       = "HTTPRequest"
					   url             = "#SESSION.root#/tools/scheduler/RunScheduler.cfm?id=#Schedule.ScheduleName##passtru#"
					   group           = "#Schedule.SystemModule#" 
					   resolveURL      = "Yes"
					   publish         = "Yes"
					   file            = "#Schedule.ScheduleName#.txt"
					   path            = "#parameter.schedulerroot#"
					   onmisfire	   = "#Schedule.ScriptMisfire#">
					   
					   <!--- requestTimeOut  = "#Schedule.ScriptTimeOut#" --->
					   
				<!--- Re-build the list of tasks chained to the parent task --->
					   
				 <cfquery name="ChainedTasks" 
					datasource="AppsSystem" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">

						SELECT ScheduleName + ':' +SystemModule AS Task
						FROM   Schedule
						WHERE  ParentScheduleId = '#Schedule.ParentScheduleId#'
					
				 </cfquery> 
				 
				 <cfset taskList = ValueList(ChainedTasks.Task,",")>
				 
				 <cfquery name="Parent" 
					datasource="AppsSystem" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					
						SELECT *
						FROM   Schedule
						WHERE  ScheduleId = '#Schedule.ParentScheduleId#'
					
				 </cfquery> 
				 
				 <cfif Parent.SchedulePassThru neq "">
					<cfset passtru = "&#Parent.SchedulePassThru#">
				 <cfelse>
				    <cfset passtru = "">
				 </cfif>		
				 
				<cfif Parent.ScheduleEndTime eq "">
					
					<cfschedule action = "update"
					   task            = "#Parent.ScheduleName#" 
					   operation       = "HTTPRequest"
					   url             = "#SESSION.root#/tools/scheduler/RunScheduler.cfm?id=#Parent.ScheduleName##passtru#"
					   startDate       = "#dateFormat(Parent.ScheduleStartDate,client.DateSQL)#"
					   startTime       = "#Parent.ScheduleStartTime#"
					   interval        = "#Parent.ScheduleInterval#"
					   group           = "#Parent.SystemModule#" 
					   resolveURL      = "Yes"
					   publish         = "Yes"
					   file            = "#Parent.ScheduleName#.txt"
					   path            = "#parameter.schedulerroot#"
					   onmisfire	   = "#Schedule.ScriptMisfire#"					   
					   oncomplete	   = "#taskList#">
					   
					   <!--- requestTimeOut  = "#Schedule.ScriptTimeOut#" --->
				   
				<cfelse>
				  
				  	<cfschedule action = "update"
					   task            = "#Parent.ScheduleName#" 
					   operation       = "HTTPRequest"
					   url             = "#SESSION.root#/tools/scheduler/RunScheduler.cfm?id=#Parent.ScheduleName##passtru#"
					   startDate       = "#dateFormat(Parent.ScheduleStartDate,client.DateSQL)#"
					   startTime       = "#Parent.ScheduleStartTime#"
					   endDate         = "#dateFormat(Parent.ScheduleEndDate,client.DateSQL)#"
					   endTime         = "#Parent.ScheduleEndTime#"
					   group           = "#Parent.SystemModule#" 
					   interval        = "#Parent.ScheduleInterval#"
					   resolveURL      = "Yes"
					   publish         = "Yes"
					   file            = "#Parent.ScheduleName#.txt"
					   path            = "#parameter.schedulerroot#"
					   onmisfire	   = "#Schedule.ScriptMisfire#"					   
					   oncomplete	   = "#taskList#">
					   
					   <!--- requestTimeOut  = "#Schedule.ScriptTimeOut#" --->
				  	  
				</cfif> 
				 
				 
			</cfif>
			
			<cffile action="WRITE" file="#parameter.schedulerroot#\#Schedule.ScheduleName#.html" 
			output="init" addnewline="Yes" fixnewline="No">
		  
	   </cfif>
	
	</cfoutput>
	
	<cfquery name="Update"
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE Schedule
		SET    Operational = '#op#'
		WHERE  ScheduleId = '#URL.ID#'
	</cfquery>

</cfif>	

<cf_compression>
