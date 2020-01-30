
<cf_preventCache>

<cftransaction>

	<cfquery name="Update" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE Ref_ParameterMission
				SET <cfif Form.DefaultAllotmentPeriod eq "">
						DefaultAllotmentPeriod     = NULL,
					<cfelse>
						DefaultAllotmentPeriod     = '#Form.DefaultAllotmentPeriod#',
					</cfif>
					EnableForecast                 = '#Form.EnableForecast#', 
					DefaultAllotmentView           = '#Form.DefaultAllotmentView#',
					BudgetObjectMode               = '#Form.BudgetObjectMode#',
					BudgetAmountMode               = '#Form.BudgetAmountMode#',
					BudgetLocation                 = '#Form.BudgetLocation#',
					BudgetTransferMode             = '#Form.BudgetTransferMode#',
					BudgetRequirementMode          = '#Form.BudgetRequirementMode#',
					BudgetRequirementLocation      = '#Form.BudgetRequirementLocation#',
					<cfif form.supportObjectCode eq "">
					SupportObjectCode = NULL,
					<cfelse>
					SupportObjectCode = '#form.supportObjectCode#',
					</cfif>
					<cfif form.BudgetCategory neq "">
					BudgetCategory                 = '#Form.BudgetCategory#',
					<cfelse>
					BudgetCategory                 = NULL,
					</cfif>
					BudgetClearanceMode            = '#Form.BudgetClearanceMode#'
			WHERE 	Mission                        = '#url.Mission#'
	</cfquery>
	
</cftransaction>

<cfoutput>
	<script>
		ColdFusion.navigate("ParameterBudgetMenu.cfm?idmenu=#URL.IDMenu#&mission=#url.Mission#&selected=1", "contentbox5");
	</script>
</cfoutput>