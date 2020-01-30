<cfquery name="GetGroups"
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM   Ref_PayrollTriggerGroup
	WHERE  SalaryTrigger = '#URL.payrollTrigger#'
	ORDER BY ListingOrder ASC
</cfquery>

<table width="100%" class="navigation_table">
	<tr class="line">
		<td class="labelit" align="center" width="2%"></td>
		<td class="labelmedium" style="padding-left:10px;"><cf_tl id="Group"></td>
		<td class="labelmedium"><cf_tl id="Name"></td>
		<td class="labelmedium"><cf_tl id="Priority"></td>
		<td class="labelmedium"><cf_tl id="Mode"></td>
		<td class="labelmedium"><cf_tl id="Range"></td>
	</tr>
	<cfoutput query="GetGroups">
		<tr class="navigation_row">
			<td>
				<table width="100%">
					<tr>
						<td style="padding-left:5px;padding-top:4px">
							<cf_img icon="edit" navigation="yes" onclick="editGroup('#url.payrollTrigger#', '#EntitlementGroup#');">
						</td>
						<td style="padding-left:5px;">

							<cfquery name="validatePurge"
							datasource="AppsPayroll" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								SELECT 	EntitlementGroup
								FROM   	PersonEntitlement
								WHERE  	SalaryTrigger = '#URL.payrollTrigger#'
								AND 	EntitlementGroup = '#EntitlementGroup#'
								UNION ALL
							    SELECT 	EntitlementGroup
								FROM   	PersonDependentEntitlement
								WHERE  	SalaryTrigger = '#URL.payrollTrigger#'
								AND 	EntitlementGroup = '#EntitlementGroup#'
								UNION ALL
								SELECT 	EntitlementGroup
								FROM   	Ref_PayrollComponent
								WHERE  	SalaryTrigger = '#URL.payrollTrigger#'
								AND 	EntitlementGroup = '#EntitlementGroup#'
							</cfquery>

							<cfif validatePurge.recordCount eq 0>
								<cf_img icon="delete" onclick="removeGroup('#url.payrollTrigger#', '#EntitlementGroup#');">
							</cfif>

						</td>
					</tr>
				</table>
			</td>
			<td class="labelmedium" style="padding-left:10px;">#EntitlementGroup#</td>
			<td class="labelmedium">#EntitlementName#</td>
			<td class="labelmedium">#EntitlementPriority#</td>
			<td class="labelmedium">#ApplyMode#</td>
			<td class="labelmedium">#ApplyRangeFrom# - #ApplyRangeTo#</td>
		</tr>
	</cfoutput>
</table>

<cfset ajaxOnLoad("doHighlight")>