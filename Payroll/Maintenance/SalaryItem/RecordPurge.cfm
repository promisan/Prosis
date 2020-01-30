
<cftransaction>

	<cfquery name="DeleteDetail" 
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			DELETE FROM SalarySchedulePayrollItem	
			WHERE PayrollItem  = '#url.id1#'
	</cfquery>
	
	<cfquery name="Delete" 
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			DELETE FROM Ref_PayrollItem	
			WHERE PayrollItem  = '#url.id1#'
	</cfquery>

</cftransaction>

<cfoutput>
	<script language="JavaScript">
	     ColdFusion.navigate('RecordListing.cfm?idmenu=#url.idmenu#','divDetail');
	</script> 
</cfoutput>