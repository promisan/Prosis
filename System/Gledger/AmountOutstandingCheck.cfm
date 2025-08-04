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
<cfset actAmountOut = 1>
<cfset actITS		= 0>

<cfquery  name 			= "getTrans"
		  datasource 	= "appsQuery" 
		  username		="#SESSION.login#"
		  password		="#SESSION.dbpw#">
		  SELECT TOP 5000 *
		  FROM (
				  SELECT  Journal, JournalSerialNo, 
				         (SELECT TOP 1 ISNULL(ActionDate,'01/01/2000')
						  FROM   Accounting.dbo.TransactionHeaderAction
						  WHERE  Journal = H.Journal 
						  AND    JournalSerialNo = H.JournalSerialNo
						  AND    ActionCode = 'Outstanding'
						  ORDER BY ActionDate DESC) as LastDate
				  FROM 	 Accounting.dbo.TransactionHeader H WITH (NOLOCK)
				  WHERE  TransactionCategory in ('Receivables','Payables')
				  AND	 ActionStatus IN ('0','1')
				  AND 	 RecordStatus !='9'
				  AND  (  AccountPeriod IN
		                             ( SELECT  AccountPeriod
		                               FROM    Accounting.dbo.Period
		                               WHERE   ActionStatus = '0')
					OR AmountOutstanding > 0 )
				   ) as B			   
			ORDER BY LastDate      					   
							   
</cfquery>

<!--- for each of these debits, must check the amount outstanding and review the payments done to each to see if it matches on the balance ---->

<cfset row = 0>

<cfloop query = "getTrans">

	<cfset row = row+1>

	<cf_TransactionOutstanding 
	    journal="#getTrans.Journal#" 
	    journalserialNo="#getTrans.JournalSerialNo#">
		
	 <cfset val = row/100>
	 
	 <cfif val eq "1">
	 
	 <cf_ScheduleLogInsert
	   	ScheduleRunId  = "#schedulelogid#"
		Description    = "#currentrow# of #recordcount#"
		StepStatus     = "1">	 
		
		<cfset row = 0>
		
	 </cfif>	 	
		
</cfloop>

<cf_ScheduleLogInsert
   	ScheduleRunId  = "#schedulelogid#"
	Description    = "Process Finished"
	StepStatus     = "1">
