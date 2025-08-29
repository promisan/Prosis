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
<cfinvoke component="Service.Access"  
	Method         = "budget"
	Mission		   = "#url.mission#"
	Period         = "#url.period#"		
	Role           = "'BudgetManager'"
	ReturnVariable = "BudgetManagerAccess">

<cfquery name="Edition" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   Ref_AllotmentEdition	
		WHERE  Mission = '#URL.Mission#'	
		AND   ( Period IN ( SELECT Period 
		                   FROM   Organization.dbo.Ref_MissionPeriod
	                       WHERE  Mission = '#url.Mission#'	
	                       AND    PlanningPeriod  = '#URL.Period#' )
		       or Period is NULL)
		<cfif BudgetManagerAccess eq "EDIT" or BudgetManagerAccess eq "ALL">
			<!--- nothing --->
		<cfelse>
			AND    Status != '9' 
		</cfif>
</cfquery>	

<cfif Edition.recordcount eq "0">

	No locked editions found
	
<cfelse>
	
	<cfoutput>
	<select name="editionid" class="regularxl" id="editionid"
	   onchange="ColdFusion.navigate('TransferDialogResource.cfm?mission=#url.mission#&editionid='+this.value+'&period=#url.period#','resourcebox')">
		<cfloop query="edition">
			<option value="#editionid#" <cfif url.editionid eq editionid>selected</cfif>>#editionid# #Description#</option>
		</cfloop>
	</select>	
	</cfoutput>
		
</cfif>	

<!---
<cfoutput>
	<script>
	  ColdFusion.navigate('TransferDialogResource.cfm?mission=#url.mission#&editionid=#edition.editionid#&period=#url.period#','resourcebox') 
	</script>
</cfoutput>
--->
