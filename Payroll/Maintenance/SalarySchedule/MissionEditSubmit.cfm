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
 

<cfparam name="Form.SettleInitialMode" default="0">
<cfparam name="Form.SettleInitial" default="100">

<cfif url.action eq "delete">
 
<cfquery name="Delete"
  datasource="AppsPayroll" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
     DELETE FROM SalaryScheduleMission
	 WHERE  SalarySchedule  = '#URL.Schedule#'
	 AND    Mission  = '#URL.Mission#' 
</cfquery>

<cfelseif url.action eq "update">

	<cfset dateValue = "">
	<CF_DateConvert Value="#form.DateEffective#">
	<cfset STR = dateValue>
			
	<cf_verifyOperational 
	         datasource= "appsSystem"
	         module    = "Accounting" 
			 Warning   = "No">
	  
	<cfquery name="Update"
	  datasource="AppsPayroll" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	     UPDATE SalaryScheduleMission
		 SET    DateEffective          = #STR#,
		        SettleInitialMode      = '#form.settleInitialMode#',
				<cfif form.settleinitialmode eq "0">
				SettleInitial          = '100'
				<cfelse>
				SettleInitial          = '#form.settleInitial#'	 	 
				</cfif>
		        <cfif operational eq "1">
		        , GLAccount = '#Form.GLAccount#'
		        </cfif>			  	 	
		 WHERE  SalarySchedule  = '#URL.Schedule#'
		 AND    Mission         = '#URL.Mission#'
		
	</cfquery>
	
	<cfquery name="Update"
	  datasource="AppsPayroll" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	     DELETE FROM SalaryScale
		 WHERE  SalarySchedule  = '#URL.Schedule#'
		 AND    Mission         = '#URL.Mission#'
		 AND    SalaryEffective < #STR#
	</cfquery>
	
	<cfquery name="Clear"
	  datasource="AppsPayroll" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	     DELETE FROM EmployeeSalary
		 WHERE  SalarySchedule  = '#URL.Schedule#'
		 AND    Mission         = '#URL.Mission#'
		 AND    PayrollStart < #STR#
	</cfquery>
			
</cfif>

<cfoutput>
<script language="JavaScript">   
     ProsisUI.closeWindow('misdialog')
	 ptoken.location('RecordListing.cfm?idmenu=#url.idmenu#&init=1')       
</script>  
</cfoutput>
	

