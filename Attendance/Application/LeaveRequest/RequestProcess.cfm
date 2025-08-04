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

<cfquery name="check" 
  datasource="AppsEmployee" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
  SELECT *
  FROM PersonLeave
  WHERE LeaveId = '#URL.ID#'
</cfquery>

<cfquery name="delete" 
  datasource="AppsEmployee" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
  DELETE FROM PersonLeave
  WHERE LeaveId = '#URL.ID#'
</cfquery>

<cfquery name="leavetype" 
  datasource="AppsEmployee" 
  maxrows=1 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
  SELECT *
  FROM Ref_LeaveType
  WHERE LeaveType = '#Check.leaveType#'
</cfquery>

<cfif LeaveType.LeaveAccrual neq "0">

	<cfinvoke component  = "Service.Process.Employee.Attendance"  
		   method        = "LeaveBalance" 
		   PersonNo      = "#check.PersonNo#" 			   
		   LeaveType     = "#check.LeaveType#"
		   BalanceStatus = "0"
		   StartDate     = "#Check.DateEffective#"
		   EndDate       = "#Check.DateExpiration#">		
      			 
</cfif>

<cfoutput>

<cfif URL.Source eq "Manual">

   <script language="JavaScript">
    window.location = "#SESSION.root#/Staffing/Application/Employee/Leave/EmployeeLeave.cfm?ID=#check.PersonNo#"	
   </script>

<cfelse>

   <script language="JavaScript">
      window.location = "Request1.cfm?ID=#check.PersonNo#"	
   </script> 
   
</cfif>   

</cfoutput>
