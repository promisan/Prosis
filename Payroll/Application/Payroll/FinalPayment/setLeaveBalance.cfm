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

<cfset st = createDate(year(get.PaymentDate),month(get.PaymentDate),1)>
<cfset ed = createDate(year(get.PaymentDate),month(get.PaymentDate),day(get.PaymentDate))>

<!--- obtain the EOD date of the person to be recalculated leave from the start --->

<cfif EOD neq "">

	<!--- recalculated it now --->

	<cfquery name="LeaveType" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	 
 	  SELECT    LeaveType
      FROM      Ref_LeaveType
      WHERE     EnablePayroll = '1' 	 	
	</cfquery>
			
	<cfloop query="LeaveType">
															
		<cfinvoke component = "Service.Process.Employee.Attendance"  
		   method           = "LeaveBalance" 
		   PersonNo         = "#get.PersonNo#" 
		   Mission          = "#get.Mission#"
		   LeaveType        = "#LeaveType#"		
		   Mode             = "regular"
		   BalanceStatus    = "#BalanceStatus#"  <!--- put this information in a different status to not mess with the current --->		   		   
		   StartDate        = "#min#" 
		   EndDate          = "#max#">			   
	
	</cfloop>  		

</cfif>
	