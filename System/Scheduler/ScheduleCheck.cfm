<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
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

<cfquery name="Schedule"
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM   Schedule S	
</cfquery>

<cfschedule  
    action = "list" 
    mode = "server"
    result = "CFScheduleList">

<cf_distributer>

<cfoutput query="schedule">

<!--- check --->

	<cfquery name="Check" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM  Schedule R, 
		      Ref_SystemModule S		  
		WHERE R.SystemModule = S.SystemModule
		AND   R.Operational = 1
		<cfif master eq "0">
		AND ScheduleName NOT IN ('Template','CMManager','DataDictionary')
		</cfif>			
		AND   S.Operational = '1'	
		AND   R.ScheduleId = '#ScheduleId#'
	</cfquery>
	
	<cfif Check.recordcount eq "0">
	
		<cftry>
	
		<cfschedule action="DELETE" task="#ScheduleName#">
		
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
	
		<cfquery name="Host" 
		datasource="AppsInit">
			SELECT *
			FROM   Parameter P 
			WHERE  P.HostName = '#CGI.HTTP_HOST#' 
		</cfquery>
		
	    <cfif operational eq 0 
		     or ScheduleInterval eq "Manual" 
			 or ApplicationServer neq host.Applicationserver>
		
			<cftry>
			
			<cfschedule action="DELETE" task="#ScheduleName#">
			
			<cfcatch></cfcatch>
		
			</cftry>
		
		<cfelse>
		
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
					   requestTimeOut  = "#Schedule.ScriptTimeOut#"
   					   oncomplete	   = "#taskList#">
				   
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
					   requestTimeOut  = "#Schedule.ScriptTimeOut#"
					   oncomplete	   = "#taskList#">
				  	  
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
					   onmisfire	   = "#Schedule.ScriptMisfire#"
					   requestTimeOut  = "#Schedule.ScriptTimeOut#">
					   
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
					   requestTimeOut  = "#Parent.ScriptTimeOut#"
					   oncomplete	   = "#taskList#">
				   
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
					   requestTimeOut  = "#Parent.ScriptTimeOut#"
					   oncomplete	   = "#taskList#">
				  	  
				</cfif> 
				 
				 
			</cfif>
		
		
		
		
		
		<!---
		
			<cfif SchedulePassThru neq "">
				<cfset passtru = "&#Schedule.SchedulePassThru#">
			<cfelse>
			    <cfset passtru = "">
			</cfif>	
		
			<cfif ScheduleEndTime eq "">
				
				<cfschedule action = "update"
				   task            = "#ScheduleName#" 
				   operation       = "HTTPRequest"
				   url             = "#SESSION.root#/tools/scheduler/RunScheduler.cfm?id=#ScheduleName##passtru#"
				   startDate       = "#dateFormat(ScheduleStartDate,client.DateSQL)#"
				   startTime       = "#ScheduleStartTime#"
				   interval        = "#ScheduleInterval#"
				   group           = "#SystemModule#" 
				   resolveURL      = "Yes"
				   publish         = "Yes"
				   file            = "#ScheduleName#.html"
				   path            = "#Host.schedulerroot#"
				   requestTimeOut  = "#ScriptTimeOut#"				   
				   oncomplete	   = "#taskList#">
			   
			<cfelse>
			  
			  	<cfschedule action = "update"
				   task            = "#ScheduleName#" 
				   operation       = "HTTPRequest"
				   url             = "#SESSION.root#/tools/scheduler/RunScheduler.cfm?id=#ScheduleName##passtru#"
				   startDate       = "#dateFormat(ScheduleStartDate,client.DateSQL)#"
				   startTime       = "#ScheduleStartTime#"
				   endDate         = "#dateFormat(ScheduleEndDate,client.DateSQL)#"
				   endTime         = "#ScheduleEndTime#"
				   group           = "#SystemModule#" 
				   interval        = "#ScheduleInterval#"
				   resolveURL      = "Yes"
				   publish         = "Yes"
				   file            = "#ScheduleName#.html"
				   path            = "#Host.schedulerroot#"
				   requestTimeOut  = "#ScriptTimeOut#"				   
				   oncomplete	   = "#taskList#">
			  	  
			</cfif> 
			
			--->
	  
   		</cfif>
	
	</cfif>
	

</cfoutput>

<font color="green">Successfully verified</font>

