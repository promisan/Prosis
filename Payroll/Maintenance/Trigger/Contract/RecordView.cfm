
<cfparam name="url.mid" default="">

<cfoutput>
	<iframe 
		name="groupview" 
		frameborder="0" 
		width="100%" 
		height="100%" 
		src="#session.root#/payroll/Maintenance/Trigger/Contract/RecordEdit.cfm?SalaryTrigger=#url.SalaryTrigger#&ContractType=#url.ContractType#&mid=#url.mid#">
</cfoutput>