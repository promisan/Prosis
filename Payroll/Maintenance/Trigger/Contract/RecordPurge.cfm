
<cfquery name="purge"
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    DELETE
		FROM   	Ref_PayrollTriggerContractType
		WHERE  	SalaryTrigger = '#URL.SalaryTrigger#'
		AND 	ContractType = '#URL.ContractType#'
</cfquery>

<cfoutput>
	<script>
		ptoken.navigate('#session.root#/Payroll/Maintenance/Trigger/PayrollTriggerGroup/RecordListing.cfm?payrollTrigger=#url.SalaryTrigger#','divPayrollTriggerContract');
	</script>
</cfoutput>