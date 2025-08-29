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
<!--- the following are the steps 

Loop through active actions 

    Loop through the enabled (operational) journals for that action 
	
	     Determine which transaction will be actioned
		          - open
				  - leadtime : if action was performed NN days ago already
				  
		 Loop through the transactions
		 
		       Perform action : custom code (prepare report and send mail)
			   
			   Record the action in TransactionHeaderAction
			   
			   
  
--->


<cf_assignid>
<cfparam name="schedulelogid" default="#rowguid#">

<cfquery name="Actions" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
	SELECT *
	FROM    Ref_Action
	WHERE   Operational = 1
	AND Template IS NOT NULL
</cfquery>

<!---
<cftry>
--->

<cfloop query="Actions">
<!---	
    <cf_ScheduleLogInsert
	   	ScheduleRunId  = "#schedulelogid#"
    	Description    = "#Description#">		
--->
	
    <cfset customform =  Template>
	<cfset lead       =  LeadDays>
	
	<cfquery name="JournalAction" 
		datasource="AppsLedger" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">		
		SELECT *
		FROM   JournalAction
		WHERE  ActionCode = '#Code#'
		AND    Operational = 1
	</cfquery>

		
	<cfloop query="JournalAction">		
	
    	<!--- ATTENTION --->
    	<!--- review query based on the settings of the action. --->	

		<cfquery name="getTransactions" 
			datasource="AppsLedger" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
		       
			SELECT H.TransactionId,H.Journal, H.JournalSerialNo, H.Mission, convert(varchar,H.TransactionDate,101) as TransactionDate
			FROM   TransactionHeader H
			WHERE  H.Journal = '#JournalAction.Journal#' 
			<cfif Actions.IsOpen eq "1">	
			AND    H.AmountOutstanding > 0.05			<!--- to avoid rounding issues --->
			</cfif>
			AND NOT EXISTS (SELECT * 
							FROM TransactionHeaderAction HA
							WHERE HA.Journal = H.Journal
							AND HA.JournalSerialNo = H.JournalSerialNo)
			
			<cfif Actions.IsOpen eq "1">				
				UNION 
				
				SELECT DISTINCT TransactionId,H.Journal, H.JournalSerialNo, H.Mission, convert(varchar,H.TransactionDate,101) as TransactionDate
				FROM   TransactionHeader H, TransactionHeaderAction HA
				WHERE  H.Journal = '#JournalAction.Journal#'
				AND    H.AmountOutstanding > 0.05	
				AND    HA.Journal = H.Journal
				AND    HA.JournalSerialNo = H.JournalSerialNo
				AND    DateDiff(day,HA.ActionDate,getdate()) >= '#lead#'			
			</cfif>
			
		</cfquery>		
		
		<!----
		<cf_ScheduleLogInsert
	   	ScheduleRunId  = "#schedulelogid#"
    	Description    = "#Journal# #Transactions.recordcount#">		
		--->
		
		<cfloop query="getTransactions">
				    
			<cfquery name="ActionSerialNo" 
					datasource="AppsLedger" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">	
					
					SELECT ISNULL(MAX(ActionSerialNo),0)+1 as NextSerialNo
					FROM   TransactionHeaderAction
					WHERE  Journal = '#getTransactions.Journal#'
					AND    JournalSerialNo = '#getTransactions.JournalSerialNo#'
					AND    ActionCode = '#Actions.Code#'
			</cfquery>


			<cfset action = "0">
		
			<!--- Perform a custom Action as defined by the template --->
			<cfinclude template="../../../../#Actions.Template#">
			
			<!--- log the action which was performed --->
			
			
			<cfif action eq "1">
			
			
				<cfquery name="TransactionAction" 
					datasource="AppsLedger" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">	
				
					INSERT INTO TransactionHeaderAction (
							Journal,
							JournalSerialNo,							
							ActionCode,
							ActionSerialNo,
							ActionDate,
							OfficerUserId,
							OfficerLastName,
							OfficerFirstName)
					VALUES ('#getTransactions.Journal#',
							'#getTransactions.JournalSerialNo#',
							'#Actions.Code#',
							'#ActionSerialNo.NextSerialNo#',
							getDate(),
							'#SESSION.acc#',
							'#SESSION.last#',					
							'#SESSION.first#')
									
				</cfquery>
			</cfif>
			<!--- attach the generated invoice --->
			
		</cfloop>		
	</cfloop>	
</cfloop>

<!---
<cfcatch>
	<cfoutput>
	<script>alert("#cfcatch.message#")</script>
	</cfoutput>
</cfcatch>
</cftry>
--->