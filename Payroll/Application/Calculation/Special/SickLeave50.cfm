
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
