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

<cfquery name="getPeriod" 
	datasource="appsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT	PlanningPeriod
		FROM	Ref_MissionPeriod
		WHERE	Mission = '#url.mission#'
		ORDER BY PlanningPeriod ASC
</cfquery>

<cf_tl id = "Please, select a valid period" var = "1">

<!-- <cfform method="POST" name="frmReviewCycle"> -->
	<table>
		<tr>
			<cfselect 
				name="Period" 
				query="getPeriod" 
				value="PlanningPeriod" 
				display="PlanningPeriod" 
				selected="#url.period#" 
				required="Yes" 
				class="regularxl" 
				message="#lt_text#" 
				onchange="ColdFusion.navigate('#session.root#/ProgramREM/Maintenance/ReviewCycle/setDate.cfm?id1=#url.id1#&period='+this.value+'&name=Effective&blank=1','divEffectiveDate'); ColdFusion.navigate('#session.root#/ProgramREM/Maintenance/ReviewCycle/setDate.cfm?id1=#url.id1#&period='+this.value+'&name=Expiration&blank=1','divExpirationDate');">
			</cfselect>
		</tr>
	</table>
<!-- </cfform> -->