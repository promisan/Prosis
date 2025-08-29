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
<cf_systemscript>

<cftransaction>
	
	<cfquery name="schedule" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   SalarySchedulePeriod
		WHERE  CalculationId = '#URL.ID#'
	</cfquery>
	
	<cfquery name="CleanEntitlement" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		 DELETE FROM EmployeeSalary
		 WHERE  Mission        = '#schedule.Mission#'
		 AND    SalarySchedule = '#schedule.SalarySchedule#'
		 AND    PayrollEnd     = '#dateformat(Schedule.PayrollEnd,Client.dateSQL)#'	
	</cfquery>
			
	<!--- reset the settlement status --->
	
	<cfquery name="CleanMiscellaneous" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE PersonMiscellaneous
		SET    Status = '2'
		FROM   PersonMiscellaneous R
		WHERE  R.Status = '5'
		AND    R.CostId NOT IN (SELECT ReferenceId
	                            FROM   EmployeeSalaryLine
					   		    WHERE  ReferenceId = R.CostId )	
	</cfquery>
	
	<cfquery name="CleanOvertime" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE  PersonOvertime
		SET     Status = '2'
		FROM    PersonOvertime R
		WHERE   Status = '5'
		AND     OvertimeId NOT IN ( SELECT ReferenceId
		                            FROM   EmployeeSalaryLine
					   		        WHERE  ReferenceId = R.OvertimeId )		
	</cfquery>
	
	<!--- we better let the batch process itself clean the settlements --->
	
	<cfquery name="CleanPayment" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM EmployeeSettlement
		WHERE  Mission        = '#schedule.Mission#'
		AND    SalarySchedule = '#schedule.SalarySchedule#'
		AND    PaymentDate    = '#dateformat(Schedule.PayrollEnd,Client.dateSQL)#'		
		AND    PaymentStatus  = '0' <!--- in cycle --->
		<!---
		AND    PaymentFinal   = '0' <!--- prevent workflows to be removed ---> 
		--->
	</cfquery>	
	
	<cfquery name="CleanEntitlement" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		 DELETE FROM EmployeeSettlementAudit
		 WHERE  Mission        = '#schedule.Mission#'
		 AND    SalarySchedule = '#schedule.SalarySchedule#'
		 AND    PayrollEnd     = '#dateformat(Schedule.PayrollEnd,Client.dateSQL)#'	
		 AND    PaymentStatus  = '0'
	</cfquery>
	
	<cfquery name="CleanLog" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM CalculationLogSettlementLine
		WHERE  Mission        = '#schedule.Mission#'
		AND    SalarySchedule = '#schedule.SalarySchedule#'
		AND    PaymentDate    = '#dateformat(Schedule.PayrollEnd,Client.dateSQL)#'	
		AND    PaymentStatus  = '0' <!--- in cycle --->
		<!---
		AND    PaymentStatus  = '0' <!--- in cycle --->
		AND    PaymentFinal   = '0' <!--- prevent workflows to be removed ---> 
		--->
	</cfquery>
	
	<cfquery name="delete" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM SalarySchedulePeriod
		WHERE  Mission        = '#schedule.Mission#'
		AND    SalarySchedule = '#schedule.SalarySchedule#'
		AND    PayrollEnd    >= '#dateformat(Schedule.PayrollEnd,Client.dateSQL)#'	
	</cfquery>

</cftransaction>

<script>
	history.go()
</script>

