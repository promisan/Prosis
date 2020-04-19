
<!--- run init.cfm --->

<cfparam name="SESSION.acc"       default="Batch">
<cfparam name="CLIENT.style"     default="/Portal/Logon/Bluegreen/pkdb.css">
<cfparam name="URL.ID"           default="0">
<cfparam name="URL.IDLog"        default="0">
<cfparam name="URL.Batch"        default="1">
<cfparam name="URL.mode"         default="scheduler">

<cfif url.mode eq "Scheduler">

	<cfinclude template="../CFReport/Anonymous/PublicInit.cfm">
	
	<cfquery name="Template"
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT * FROM Schedule
		WHERE  ScheduleName = '#URL.ID#'
	</cfquery>
	
	<cf_assignId>	
	<cfset schedulelogid = rowguid>
	
<cfelseif url.mode eq "Manual">

	<cfquery name="Template"
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT * FROM Schedule
		WHERE  ScheduleName = '#URL.ID#'
	</cfquery>
	
	<cf_assignId>
	<cfset schedulelogid = rowguid>
		
<cfelse>

	<cfquery name="Template"
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT * 
		FROM   Schedule
		WHERE  ScheduleId = '#URL.ID#'
	</cfquery>
	
	<cfset schedulelogid = url.idlog>	
	
</cfif>	


<cfoutput>

<cfif url.mode eq "Manual">

		<cfquery name="Insert"
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    INSERT INTO ScheduleLog
				       (ScheduleId, ScheduleRunId,ScheduleMode)
				VALUES ('#Template.scheduleId#','#schedulelogid#','Manual') 
		</cfquery>
	
		<cfset runId = schedulelogid>
	
		<cfinclude template="../../#template.ScheduleTemplate#">
		
		<cfquery name="Update"
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    UPDATE ScheduleLog
				SET    ProcessEnd       = getDate(),
				       NodeIP           = '#CGI.Remote_Addr#', 
					   ActionStatus     = '1',				  
					   OfficerUserId    = '#SESSION.acc#' 
				WHERE  ScheduleRunId    = '#runId#' 
			</cfquery>			
			
<cfelse>	

		<cfquery name="check"
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT * 
			FROM   ScheduleLog
			WHERE  ScheduleRunId    = '#schedulelogid#' 						
		</cfquery>
		
		<cfif check.recordcount eq "0">
		
			<cfquery name="Insert"
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    INSERT INTO ScheduleLog
				       (ScheduleId, ScheduleRunId,ScheduleMode)
				VALUES ('#Template.scheduleId#','#schedulelogid#','#url.mode#') 
			</cfquery>
		
		</cfif>
					
		<cfquery name="SParameter" 
		datasource="AppsInit">
			SELECT  *
			FROM    Parameter 
			WHERE   HostName = '#CGI.HTTP_HOST#'
		</cfquery>
		
		<cftry>
		
			<!--- run the template batch --->
									
			<cfquery name="Check"
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT TOP 1 *
					FROM   ScheduleLog S
					WHERE  ScheduleId      = '#Template.scheduleId#' 
					AND    ActionStatus    = '0'	
					AND    ScheduleRunId   != '#schedulelogid#'	
					ORDER BY Created DESC
			</cfquery>
			
			<cfif Check.recordcount gte "1" and dateDiff("d",check.created, now()) eq 0 and dateDiff("n",check.created, now()) lte 10>
			
			<!--- if the status = 2, it means one or more errors were detected --->
					
					<cfquery name="Update"
					datasource="AppsSystem" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    UPDATE ScheduleLog
						SET    ProcessEnd       = getDate(),
						       NodeIP           = '#CGI.Remote_Addr#', 							
							   ActionStatus     = '5',									    
							   OfficerUserId    = '#SESSION.acc#' 
						WHERE  ScheduleRunId    = '#schedulelogid#' 
					</cfquery>

			<cfelse>
		    	
				<cfset runId = schedulelogid>
				
				<cfinclude template="../../#template.ScheduleTemplate#">
				
				<!--- end the template batch --->
				
				<cffile action   = "READ" 
				        file     = "#sparameter.schedulerroot#\#Template.scheduleName#.html" 
						variable = "output">
						
					<cfquery name="LogStatus"
					datasource="AppsSystem" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    SELECT * 
						FROM   ScheduleLog			
						WHERE  ScheduleRunId = '#runId#' 
					</cfquery>	
					
					<!--- if the status = 2, it means one or more errors were detected --->
					
					<cfquery name="Update"
					datasource="AppsSystem" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    UPDATE ScheduleLog
						SET    ProcessEnd       = getDate(),
						       NodeIP           = '#CGI.Remote_Addr#', 
							   <cfif LogStatus.ActionStatus neq "2">
							   ActionStatus     = '3',		
							   </cfif>		  
							   OfficerUserId    = '#SESSION.acc#' 
						WHERE  ScheduleRunId    = '#runId#' 
					</cfquery>
					
					<cfquery name="Last" 
						datasource="AppsSystem" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT *
							FROM  ScheduleLog R
							WHERE ScheduleRunId = '#runId#'
						</cfquery>
					
					<!--- send email --->	 
				    <cfinclude template="MailScriptSuccess.cfm">
					
					<script language="JavaScript">
						try {
						schedulelog('#Template.scheduleId#','','show')
						} catch(e) {}
					</script>
					
				</cfif>	
								
				<cfcatch>
					    		
						<!--- update log and stop the process --->
						
						<cfset sqlError = "">
						<cfif cfcatch.type eq "database">
							<cfset sqlError = cfcatch.Sql>
						</cfif>
						
						<cfquery name="Update"
						datasource="AppsSystem" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						    UPDATE ScheduleLog
							SET    ProcessEnd        = getDate(),
								   NodeIP            = '#CGI.Remote_Addr#',
								   ScriptError       = '#CFCatch.Message# - #CFCATCH.Detail# - #sqlError#',
								   EMailSentTo       = '#Template.ScriptFailureMail#',
								   ActionStatus      = '9',
								   OfficerUserId     = '#SESSION.acc#'
							WHERE  ScheduleRunId     = '#runId#' 
						</cfquery>
						
						<cfquery name="Last" 
						datasource="AppsSystem" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT *
							FROM   ScheduleLog R
							WHERE  ScheduleRunId = '#runId#'
						</cfquery>
							
						<!--- send email --->		 
					    <cfinclude template="MailScriptFail.cfm">
						
						<script>
						try {
						schedulelog('#Template.scheduleId#','','show')
						} catch(e) {}
						</script>
						
						<cfabort>
										
				</cfcatch>
	
		</cftry>
		
</cfif>

</cfoutput>

<table><tr class="labelmedium"><td style="padding-left:10px;padding-right:10px">Batch execution completed !</td></table>



