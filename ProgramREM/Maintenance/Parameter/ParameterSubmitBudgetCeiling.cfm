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
				SET BudgetCeilingClear             = '#Form.BudgetCeilingClear#',
					BudgetCeiling                  = '#Form.BudgetCeiling#'
			WHERE 	Mission                        = '#url.Mission#'
	</cfquery>
	
	
	<cfquery name="Resource" 
		 datasource="AppsProgram" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">	
		  DELETE FROM Ref_ParameterMissionResource
		  WHERE Mission = '#url.Mission#'
	</cfquery>		
	
	<cfquery name="Resource" 
		 datasource="AppsProgram" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">	
		  SELECT     *
		  FROM       Ref_Resource
	</cfquery>	
	
	<cfloop query="Resource">
	
			<cfparam name="form.#code#_ceiling" default="0">
	
			<cfset ceil = evaluate("form.#code#_ceiling")>
		
			<cfquery name="Insert" 
			 datasource="AppsProgram" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">	
			  INSERT INTO Ref_ParameterMissionResource
			          (Mission,Resource,Ceiling)
			  VALUES  ('#url.Mission#','#Code#','#ceil#')
			</cfquery>		
				
	</cfloop>	

</cftransaction>


<cfoutput>
	<script>
		ptoken.navigate("ParameterBudgetMenu.cfm?idmenu=#URL.IDMenu#&mission=#url.Mission#&selected=2", "contentbox5");
	</script>
</cfoutput>