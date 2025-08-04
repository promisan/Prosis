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

<!--- calculate leave balances in a batch --->

<cfparam name="url.leaveType"   default="Annual">
<cfparam name="url.rows"        default="9999">
<cfparam name="url.latency"     default="100">

<cfquery name="Mission" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM     Ref_ParameterMission
	WHERE    BatchLeaveBalance = '1'	
</cfquery>

<cfquery name="LeaveType" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM     Ref_LeaveType
	WHERE    LeaveType = '#url.leaveType#'	
</cfquery>

<cfloop query="mission">

	<cf_ScheduleLogInsert   
       ScheduleRunId  = "#schedulelogid#"
	   Description    = "#Mission#"
	   StepStatus="1">
	   
	   
	   <!--- for sickleave we need to exclude interns who do not have sickleave balances --->

	<cfquery name="OnBoard" 
	 datasource="AppsEmployee"
	 maxrows="#url.rows#"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 
		 	 
	 SELECT        PersonNo, LastUpdated, Onboard
	 FROM (
		 SELECT   DISTINCT PA.PersonNo, 
		 
		  (SELECT   TOP (1) Created
           FROM     PersonLeaveBalance
           WHERE    LeaveType     = '#url.leavetype#' 
		   AND      BalanceStatus = '0' 
		   AND      PersonNo      = PA.PersonNo
           ORDER BY Created DESC) AS LastUpdated,
		 
		  (SELECT   COUNT(*) AS Expr1
           FROM     PersonContract
           WHERE    PersonNo = PA.PersonNo 
		   AND      Mission = '#mission#' 
		   AND      ActionStatus IN ('0', '1') 
		   AND      DateExpiration > GETDATE()-20) AS Onboard   <!--- has active contract --->

		 FROM     PersonAssignment PA INNER JOIN 
		          Position PO ON PO.PositionNo = PA.PositionNo INNER JOIN
				  Person P ON P.PersonNo = PA.PersonNo						
		 
		 AND      PO.MissionOperational = '#mission#'		 
		 AND      PA.DateEffective     < getdate()
		 AND      PA.DateExpiration    > getDate() - 365   <!--- only fooks on board within the last year --->
		 AND      PA.AssignmentStatus IN ('0','1')
		 AND      PA.AssignmentClass   = 'Regular'
		 AND      PA.AssignmentType    = 'Actual'
		 AND      PA.Incumbency        = '100' 
		 <!--- hardcoded for STL as interns have no SL balances --->
		 <cfif LeaveType.LeaveBalanceMode eq "Relative">
		 AND      PO.PostType != 'INTR'
		 </cfif>
		 
				 
		 AND    (  NOT EXISTS (SELECT 'X'
		                       FROM   PersonLeaveBalance
							   WHERE  LeaveType     = '#url.leaveType#'
							   AND    BalanceStatus = '0'
							   AND    PersonNo      = PA.PersonNo )
							   	
				   OR
					
				   <!--- has records not touched for a latency period --->
					
				   EXISTS     (SELECT 'X'
		                       FROM   PersonLeaveBalance
							   WHERE  LeaveType     = '#url.leaveType#'
							   AND    BalanceStatus = '0'
							   AND    LeaveTypeClass is NULL
							   AND    PersonNo      = PA.PersonNo  			   						   				  
							   AND    Created < getDate() - #url.latency# )
							   
				<cfif LeaveType.LeaveBalanceMode eq "Relative">
				
				<!--- has taken which is falling free likely as time progresses --->
							   
				 OR
					
				 EXISTS (SELECT 'X'
                         FROM   PersonLeaveBalance AS PB
						 WHERE  PersonNo      = PA.PersonNo
						 AND    LeaveType     = '#url.leaveType#'
						 AND    LeaveTypeClass is NULL
						 AND    BalanceStatus = '0'
						 AND    Taken > 0 
						 AND    DateEffective <= (SELECT  MIN(DateEffective)+63
							                      FROM    PersonLeaveBalance
						                          WHERE   PersonNo      = P.PersonNo 
												  AND     BalanceStatus = '0'
												  AND     LeaveTypeClass is NULL
												  AND     LeaveType      = '#url.leaveType#'))	
												  
												 	
													   
				</cfif>		
				
				)							   	 
				 			 
		
		 <!--- only fooks with a contract for that mission --->
		 AND    PA.PersonNo IN (SELECT PersonNo
								FROM   PersonContract L
						        WHERE  L.PersonNo      = PA.PersonNo 
								AND    Mission         = '#Mission#'
								AND    L.ActionStatus != '9') 
		 								
		 ) as D
		 WHERE    Onboard > 0
		 <!--- if it was calculated very recently we do not update yet --->
		 AND      (LastUpdated < getDate()-1 or LastUpdated is NULL)
		 ORDER BY Onboard DESC, LastUpdated			 
							
		 
	</cfquery>	
	
	<cfset cnt = 0>
	
		
	<cfloop query="Onboard">
	
		<cfset row = currentrow>
		
		<cfset cnt = cnt+1>
	
		<cfif cnt eq "5">
	
			<cf_ScheduleLogInsert   
		       ScheduleRunId  = "#schedulelogid#"
			   Description    = "Staff #currentrow# of #recordcount#"
			   StepStatus="1">
		   
		   <cfset cnt = 0>
		   
		</cfif>   
	
		<cfset per = personno>
	
		<cfquery name="LeaveType" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT    R.*, C.Description as Parent, C.ListingOrder as ParentOrder
			FROM      Ref_LeaveType R, Ref_TimeClass C 
			WHERE     R.LeaveParent = C.TimeClass
			AND       LeaveAccrual IN ('1','2')			
			-- AND      LeaveAccrual IN ('1','2','3','4')	<!--- 2 CTO --->					
			AND       LeaveType = '#url.leaveType#' 			
			ORDER BY  C.ListingOrder, R.ListingOrder 
		</cfquery>
		
		<cfloop query="LeaveType">				
				
			<!--- check if person has been calculated recently for this month 
			
			<cfquery name="check" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT   TOP 1 *
				FROM     PersonLeaveBalance 
				WHERE    PersonNo  = '#Per#'
				AND    BalanceStatus = '0'
				AND      LeaveType = '#LeaveType#'
				AND      DateEffective <= getDate()
				ORDER BY DateEffective DESC				
			</cfquery>
									
			<!--- we calculate only if this has not happened through the interface --->
						
			<cfif now()-2 gt check.created or check.recordcount eq "0">		
			
			--->
																		
				<!--- check how the system makes a start date here --->
				
										
				<cfinvoke component   = "Service.Process.Employee.Attendance"  
					    method        = "LeaveBalance" 			
				        PersonNo      = "#per#" 
						LeaveType     = "#leavetype#" 
						mission       = "#mission.mission#"
						BalanceStatus = "0"
						Mode          = "batch"
						StartDate     = "01/01/2001"  
						EndDate       = "12/31/#Year(now())#">
						
			<!---			
					
			</cfif>		
			
			--->
		  
		</cfloop> 
	
	</cfloop>

</cfloop>