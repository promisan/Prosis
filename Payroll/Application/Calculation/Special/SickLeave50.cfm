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

<!--- 
obtain if a person has been on sickleave 50
make a correction for the base salary ONLY
--->
	
<cfset basecode = "SickHalfPay">   

<cfquery name="Correction" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE   EmployeeSalaryLine
		SET      PaymentCalculation = ROUND(PaymentCalculation * ((EntitlementPeriod - EntitlementSLWOP - EntitlementSuspend - EntitlementSickLeave) / (EntitlementPeriod - EntitlementSLWOP - EntitlementSuspend)),2),
				 PaymentAmount      = ROUND(PaymentAmount      * ((EntitlementPeriod - EntitlementSLWOP - EntitlementSuspend - EntitlementSickLeave) / (EntitlementPeriod - EntitlementSLWOP - EntitlementSuspend)),2),
				 Processed = '1'
		WHERE    SalarySchedule   = '#Form.Schedule#'
		AND      PayrollStart     = #SALSTR#
		AND      Mission          = '#form.Mission#'
		<cfif Form.PersonNo neq "">
		AND      PersonNo = '#form.PersonNo#'
		</cfif>
		AND      PayrollItem IN ('A01','A03')
		AND      EntitlementSickLeave > 0
		AND      Processed = '0' 
</cfquery>
