

<cfif url.EntitlementGroup eq "">
	<cfquery name="validate"
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT 	*
			FROM   	Ref_PayrollTriggerGroup
			WHERE  	SalaryTrigger = '#URL.SalaryTrigger#'
			AND 	EntitlementGroup = '#trim(form.EntitlementGroup)#'
	</cfquery>

	<cfif validate.recordCount eq 0>
		
		<cfquery name="insert"
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				
				INSERT INTO Ref_PayrollTriggerGroup	(
						SalaryTrigger,
						EntitlementGroup,
						EntitlementName,
						EntitlementPriority,
						ApplyMode,
						ApplyRangeFrom,
						ApplyRangeTo,
						ListingOrder,
						OfficerUserId,
						OfficerLastName,
						OfficerFirstName
				) VALUES (
						'#url.SalaryTrigger#',
						'#trim(form.EntitlementGroup)#',
						'#trim(form.EntitlementName)#',
						'#trim(form.EntitlementPriority)#',
						'#trim(form.ApplyMode)#',
						'#trim(form.ApplyRangeFrom)#',
						'#trim(form.ApplyRangeTo)#',
						'#trim(form.ListingOrder)#',
						'#session.acc#',
						'#session.last#',
						'#session.first#'
					)		

		</cfquery>

		<cfoutput>
			<script>
				parent.parent.ptoken.navigate('#session.root#/Payroll/Maintenance/Trigger/PayrollTriggerGroup/RecordListing.cfm?payrollTrigger=#url.SalaryTrigger#','divPayrollTriggerGroup');
				parent.parent.ProsisUI.closeWindow('weditgroup',true);
			</script>
		</cfoutput>

	<cfelse>

		<cf_tl id="This group is already registered for this trigger." var="1">
		<cfoutput>
			<script>
				alert('#lt_text#');
			</script>
		</cfoutput>
		
	</cfif>

<cfelse>

	<cfquery name="update"
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE 	Ref_PayrollTriggerGroup
			SET 	EntitlementName     = '#trim(form.EntitlementName)#',
					EntitlementPriority = '#trim(form.EntitlementPriority)#',
					ApplyMode           = '#trim(form.ApplyMode)#',
					ApplyRangeFrom      = '#trim(form.ApplyRangeFrom)#',
					ApplyRangeTo        = '#trim(form.ApplyRangeTo)#',
					ListingOrder        = '#trim(form.ListingOrder)#'
			WHERE  	SalaryTrigger       = '#URL.SalaryTrigger#'
			AND 	EntitlementGroup    = '#URL.EntitlementGroup#'
	</cfquery>

	<cfoutput>
		<script>
			parent.parent.ptoken.navigate('#session.root#/Payroll/Maintenance/Trigger/PayrollTriggerGroup/RecordListing.cfm?payrollTrigger=#url.SalaryTrigger#','divPayrollTriggerGroup');
			parent.parent.ProsisUI.closeWindow('weditgroup',true);
		</script>
	</cfoutput>

</cfif>