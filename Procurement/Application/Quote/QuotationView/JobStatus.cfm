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
<cftransaction>

	<cfquery name="Job" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT * 
		FROM   Job		
		WHERE  JobNo = '#URL.JobNo#' 
	</cfquery>	
	
	<cfquery name="UpdateStatus" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE  Job
		SET     ActionStatus = '#url.actionStatus#',
		        ActionDate   = getDate(),
				ActionUserId = '#SESSION.acc#'
		WHERE   JobNo = '#URL.JobNo#' 
	</cfquery>
	
	<cfquery name="Lines" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT    * 
		FROM      RequisitionLine
		WHERE     RequisitionNo NOT IN (SELECT RequisitionNo 
		                                FROM   PurchaseLine 
										WHERE  ActionStatus != '9')
		AND       JobNo = '#URL.JobNo#' 
	</cfquery>
	
	<cfif url.actionStatus eq "9">
	   
	   <cfset st = "9">
	   
	   
	   
	   <!--- try to deactivate the workflow as well --->
	   
	   <cfquery name="WorkflowUpdate" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE  Organization.dbo.OrganizationObject
		SET     Operational = 0
		WHERE   ObjectKeyValue1 = '#URL.JobNo#' 
		AND     EntityCode = 'ProcJob'
	  </cfquery>
	  	   
	<cfelse>
	
	   <!--- restore the last workflow as part of the default generation --->
	
	   <cfset st = "2k">  	   
	   
	</cfif>
	
	<cfloop query="Lines">
	
		<!---  1. update requisition lines --->
		<cfquery name="Update" 
		     datasource="AppsPurchase" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     UPDATE RequisitionLine
			 SET    ActionStatus    = '#st#' 
			 WHERE  RequisitionNo   = '#RequisitionNo#'
		</cfquery>
								
		<cf_assignId>
						
		<!---  2. enter action --->
		<cfquery name="InsertAction" 
		     datasource="AppsPurchase" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     INSERT INTO RequisitionLineAction 
					 (RequisitionNo, 
					  ActionId,
					  ActionStatus, 
					  ActionDate,		
					  ActionMemo,						 
					  OfficerUserId, 
					  OfficerLastName, 
					  OfficerFirstName) 
			 SELECT RequisitionNo, 
			        '#rowguid#',
			        '#st#', 
					getDate(),
					<cfif url.actionStatus eq "9"> 		
					'Cancelled from Job',			
					<cfelse>
					'Activated from Job',		
					</cfif>
					'#SESSION.acc#', 
					'#SESSION.last#', 
					'#SESSION.first#'
			 FROM   RequisitionLine
			 WHERE  RequisitionNo = '#RequisitionNo#'
		</cfquery>
	
	</cfloop>

</cftransaction>

<cfoutput>
<cfif url.ActionStatus eq "1">
	 <b><a href="javascript:ColdFusion.navigate('JobStatus.cfm?jobno=#url.jobno#&actionstatus=9','jobstatus')" title="Cancel"><font color="FF0000">Press to cancel</a></b></font>
				
<cfelse>
     <b><a href="javascript:ColdFusion.navigate('JobStatus.cfm?jobno=#url.jobno#&actionstatus=1','jobstatus')" title="Reactivate"><font color="blue">Press to activate</a></b></font>
					
</cfif>

<!--- -------------------- --->
<!--- refresh the workflow --->
<!--- -------------------- --->

<script>

 se = document.getElementById("workflowlink_#job.JobNo#")
 if (se) {
	 ColdFusion.navigate(se.value+'?ajaxid=#job.JobNo#','#job.JobNo#')
 }

</script>

</cfoutput>