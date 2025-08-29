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
				SET EnableObjective                = '#Form.EnableObjective#',
				    ObjectiveMode                  = '#Form.ObjectiveMode#',
					EnableJustification            = '#Form.EnableJustification#',
					JustificationMode              = '#Form.JustificationMode#',
					EnableRequirement              = '#Form.EnableRequirement#',
					RequirementMode                = '#Form.RequirementMode#',
					DefaultOpenProgram             = '#Form.DefaultOpenProgram#',
					ProgressMemoEnforce            = '#Form.ProgressMemoEnforce#',
					CarryOverMode                  = '#Form.CarryOverMode#',
					OutputInterface                = '#Form.OutputInterface#',
					OfficerUserId 	 			   = '#SESSION.ACC#',
					OfficerLastName  			   = '#SESSION.LAST#',
					OfficerFirstName 			   = '#SESSION.FIRST#',
					Created          			   =  getdate()					
			WHERE 	Mission                        = '#url.Mission#'
	</cfquery>

</cftransaction>

<cfoutput>
	<script>
		ptoken.navigate("ParameterEditProgram.cfm?idmenu=#URL.IDMenu#&mission=#url.Mission#", "contentbox2");
	</script>
</cfoutput>