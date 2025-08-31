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