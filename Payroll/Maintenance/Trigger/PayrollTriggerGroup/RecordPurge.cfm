
<cfquery name="validatePurge"
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	EntitlementGroup
		FROM   	PersonEntitlement
		WHERE  	SalaryTrigger = '#URL.SalaryTrigger#'
		AND 	EntitlementGroup = '#URL.EntitlementGroup#'
		UNION ALL
	    SELECT 	EntitlementGroup
		FROM   	PersonDependentEntitlement
		WHERE  	SalaryTrigger = '#URL.SalaryTrigger#'
		AND 	EntitlementGroup = '#URL.EntitlementGroup#'
		UNION ALL
		SELECT 	EntitlementGroup
		FROM   	Ref_PayrollComponent
		WHERE  	SalaryTrigger = '#URL.SalaryTrigger#'
		AND 	EntitlementGroup = '#URL.EntitlementGroup#'
</cfquery>

<cfif validatePurge.recordCount eq 0>
	<cfquery name="purge"
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    DELETE
			FROM   	Ref_PayrollTriggerGroup
			WHERE  	SalaryTrigger = '#URL.SalaryTrigger#'
			AND 	EntitlementGroup = '#URL.EntitlementGroup#'
	</cfquery>
</cfif>

<cfoutput>
	<script>
		ptoken.navigate('#session.root#/Payroll/Maintenance/Trigger/PayrollTriggerGroup/RecordListing.cfm?payrollTrigger=#url.SalaryTrigger#','divPayrollTriggerGroup');
	</script>
</cfoutput>