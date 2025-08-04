<!--
    Copyright © 2025 Promisan

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
				SET BudgetPortalPeriod             = '#Form.BudgetPortalPeriod#',
					BudgetPortalEdition            = '#Form.BudgetPortalEdition#',
					BudgetPortalMode               = '#Form.BudgetPortalMode#',
					BudgetAllotmentVerbose         = '#Form.BudgetAllotmentVerbose#',
					OfficerUserId 	 			   = '#SESSION.ACC#',
					OfficerLastName  			   = '#SESSION.LAST#',
					OfficerFirstName 			   = '#SESSION.FIRST#',
					Created          			   =  getdate()					
			WHERE 	Mission                        = '#url.Mission#'
	</cfquery>

</cftransaction>


<cfoutput>
	<script>
		ptoken.navigate("ParameterBudgetMenu.cfm?idmenu=#URL.IDMenu#&mission=#url.Mission#&selected=3", "contentbox5");
	</script>
</cfoutput>