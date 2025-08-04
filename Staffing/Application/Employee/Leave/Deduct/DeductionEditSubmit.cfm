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

<cfquery name="Leave" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   PersonLeave
	WHERE  LeaveId = '#URL.LeaveId#' 	
</cfquery>

<cfquery name="Deduction" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   PersonLeaveDeduct
	WHERE  LeaveId = '#URL.LeaveId#' 	
</cfquery>

<cfloop query="Deduction">
	
	<cfset ded = evaluate("Form.Deduction_#currentrow#")>
	<cfset mem = evaluate("Form.Memo_#currentrow#")>
	
	<cfif deduction neq ded>
		
		<cfquery name="update" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    UPDATE PersonLeaveDeduct
			SET    Deduction        = '#ded#', 
			       Mode             = 'Overwrite',
				   OfficerUserId    = '#session.acc#',
				   OfficerLastName  = '#session.last#',
				   OfficerFirstName = '#session.first#',
				   Created          = #now()#	
			WHERE  LeaveId      = '#URL.LeaveId#' 	
			AND    CalendarDate = '#calendarDate#'
		</cfquery>
	
	</cfif>
	
	<cfif memo neq mem>
	
		<cfquery name="update" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    UPDATE PersonLeaveDeduct
			SET    Memo             = '#mem#', 		     
				   OfficerUserId    = '#session.acc#',
				   OfficerLastName  = '#session.last#',
				   OfficerFirstName = '#session.first#',
				   Created          = #now()#	
			WHERE  LeaveId      = '#URL.LeaveId#' 	
			AND    CalendarDate = '#calendarDate#'
		</cfquery>
		
	</cfif> 

</cfloop>

<cfquery name="get" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT sum(Deduction) as Total
    FROM   PersonLeaveDeduct
	WHERE  LeaveId = '#URL.LeaveId#' 	
</cfquery>

<cfquery name="update" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    UPDATE PersonLeave
		SET    DaysDeduct   = '#get.total#'
		WHERE  LeaveId      = '#URL.LeaveId#' 
</cfquery>

<cfinvoke component = "Service.Process.Employee.Attendance"  
		   method        = "LeaveBalance" 
		   PersonNo      = "#Leave.PersonNo#" 			   
		   LeaveType     = "#Leave.LeaveType#"
		   BalanceStatus = "0"
		   StartDate     = "#dateformat(Leave.DateEffective,client.datesql)#">		

<cfoutput>#numberformat(get.total,'.__')#</cfoutput>

<script>
	try { ProsisUI.closeWindow('deduction',true) } catch(e) {}
</script>