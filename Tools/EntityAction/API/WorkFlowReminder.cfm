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
<!--- 1 define pending actions
      2. determine overdue.
	  3. only for enabled mission
	  4. only for action that have mail notification
	  5. look through the standard template	  
--->

<cfquery name="entity"
	datasource="AppsOrganization"
	username="#SESSION.login#"
	password="#SESSION.dbpw#">  
	SELECT * 
	FROM   Ref_Entity
	WHERE  EnableEMail         = 1
	AND    EnableEMailReminder = 1
</cfquery>	

<cf_assignid>
<cfparam name="schedulelogid"  default="#rowguid#">

<cf_ScheduleLogInsert   
   	ScheduleRunId  = "#schedulelogid#"
	Description    = "Initiate">

<cfloop query="Entity">
	
<cf_ScheduleLogInsert   
   	ScheduleRunId  = "#schedulelogid#"
	Description    = "Started #EntityCode#">

  <!--- define pending actions --->
  
  <cf_wfPending entityCode = "#entitycode#" 
                includeCompleted="No" 
				table="#SESSION.acc#PendingAction_#entitycode#">
							
	<!--- we only take pending workflow actions that fall within the boundery of the last action performed and the leadtime --->
							
	<cfquery name="Object"
		datasource="AppsQuery"
		username="#SESSION.login#"
		password="#SESSION.dbpw#">  
		SELECT A.* , 
			   AP.NotificationAttachment,
		       O.EntityGroup,
			   O.PersonEMail,		
			   O.Mission,	 
			   O.ObjectReference,
			   O.ObjectReference2,
			   O.ObjectURL,  
			   R.MailRecipient
		FROM   #SESSION.acc#PendingAction_#entitycode# A 
			   INNER JOIN  Organization.dbo.OrganizationObject O
			   		 ON    A.ObjectId   = O.ObjectId
			   INNER JOIN  Organization.dbo.Ref_Entity R
			   		 ON	   A.EntityCode = R.EntityCode
			   INNER JOIN  Organization.dbo.Ref_EntityActionPublish AP
			   		 ON    A.ActionPublishNo = AP.ActionPublishNo AND A.ActionCode = AP.ActionCode
					
		WHERE  A.EnableNotification = 1
		AND    A.ActionTakenPrior is not NULL
		AND    A.ActionLeadtime    >= 1
		AND    CONVERT(int,#now()#-A.ActionTakenPrior) >= A.ActionLeadTime 
				
	</cfquery>	
				
	<!--- back to AUTOREMIND --->
	
	<cfset eMailType = "AUTOREMIND">
	<cfset objts     = 0>
	<cfset mails     = 0>	
	<cfset counter   = 0>
				
	<cfoutput query="Object" group="ObjectId">	
				
	    <cfset NextCheck["ActionCode"]             = ActionCode>
		<cfset NextCheck["NotificationGlobal"]     = NotificationGlobal>
		<cfset NextCheck["NotificationFly"]        = NotificationFly>
		<cfset NextCheck["DueMailCode"]            = DueMailCode>
		<cfset NextCheck["NotificationAttachment"] = NotificationAttachment>
		<cfset NextCheck["ActionDescription"] 	   = ActionDescriptionDue>
				
		<!--- perform a reminder mail script for the actionId --->
		<cfset objts = objts+1>
		
		<cfset counter   = 0>
		<cfinclude template="../ProcessMail.cfm">		
		<cfset mails = mails + counter>
			
	</cfoutput>		
		
	<cf_ScheduleLogInsert   
   		ScheduleRunId  = "#schedulelogid#"
		Description    = "#EntityCode# #objts# objects with #mails# reminders sent">			
	
</cfloop>


