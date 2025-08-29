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