<!--
    Copyright © 2025 Promisan

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

<cfoutput>

<cfparam name="Attributes.Datasource"      default="appsSystem">
<cfparam name="Attributes.ScheduleRunId"   default="">
<cfparam name="Attributes.StepStatus"      default="0">
<cfparam name="Attributes.StepException"   default="">
<cfparam name="Attributes.Abort"           default="No">

<cfif attributes.scheduleRunId neq "">

   <cfquery name="Schedule" 
		datasource="#Attributes.Datasource#">
		SELECT TOP 1 *
		FROM   System.dbo.ScheduleLog
		WHERE  ScheduleRunId = '#Attributes.ScheduleRunId#'		
   </cfquery>
	
   <!--- check if exists --->
   	
   <cfif schedule.recordcount eq "1">
	
	<cfquery name="Last" 
		datasource="#Attributes.Datasource#">
		SELECT   TOP 1 *
		FROM     System.dbo.ScheduleLogDetail   
		WHERE    ScheduleRunId = '#Attributes.ScheduleRunId#'
		ORDER BY StepSerialNo DESC
	</cfquery>
	
	<cfif last.StepSerialNo eq "">
		<cfset l = 1>
	<cfelse>	
		<cfset l = Last.StepSerialNo + 1>
	</cfif>	
	
	<cftry>		
	
		<cfquery name="LogStep" 
			datasource="#Attributes.Datasource#">
			INSERT INTO System.dbo.ScheduleLogDetail   
			       	   (ScheduleRunid, 
					    StepSerialNo,
					    StepTimeStamp,				
						StepDescription,
						StepStatus,
						StepException) 
			VALUES ('#Attributes.ScheduleRunId#',
			        '#l#',
			        getDate(),			
					'#attributes.Description#',
					'#Attributes.StepStatus#',
					'#Attributes.StepException#')
		</cfquery>
	
		<cfcatch></cfcatch>
	
	</cftry>
	
	<cfif attributes.StepStatus eq "9" and attributes.Abort eq "No">
	
			<!--- one or more not stopping errors were detected --->
								
			<cfquery name="Update"
			datasource="#Attributes.Datasource#">
			    UPDATE  System.dbo.ScheduleLog
				SET     ActionStatus      = '2'
				WHERE   ScheduleRunId     = '#Attributes.ScheduleRunId#' 
			</cfquery>	
	
	<cfelseif attributes.StepStatus eq "9" and attributes.Abort eq "Yes">
	
		    <!--- update log --->
		
			<cfquery name="Template"
			datasource="#Attributes.Datasource#">
			    SELECT *
				FROM   System.dbo.Schedule
				WHERE  ScheduleName = '#URL.ID#'
			</cfquery>
								
			<cfquery name="Update"
			datasource="#Attributes.Datasource#">
			    UPDATE System.dbo.ScheduleLog
				SET    ProcessEnd        = getDate(),
					   NodeIP            = '#CGI.Remote_Addr#',					  
					   EMailSentTo       = '#Template.ScriptFailureMail#',
					   ActionStatus      = '9',
					   OfficerUserId     = '#SESSION.acc#'
				WHERE  ScheduleRunId     = '#Attributes.ScheduleRunId#' 
			</cfquery>
						
			<cfquery name="Last" 
			datasource="#Attributes.Datasource#">
			SELECT *
			FROM   System.dbo.ScheduleLog R
			WHERE  ScheduleRunId = '#Attributes.scheduleRunid#'
			</cfquery>
							
			<!--- send email --->		 
		    <cfinclude template="MailScriptFail.cfm">	
						
			<cfabort>
				
	</cfif>
	
 </cfif>
	
</cfif>

</cfoutput>