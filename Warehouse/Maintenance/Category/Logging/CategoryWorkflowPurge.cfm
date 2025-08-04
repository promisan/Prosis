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
<cfquery name="delete" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE
		FROM 	Ref_AssetActionCategoryWorkflow
		WHERE	ActionCategory = '#url.action#'
		AND		Category = '#url.category#'
		AND		Code = '#url.code#'
</cfquery>

<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
	                         action ="Delete"
							 contenttype="Scalar" 
							 content="ActionCategory:#url.action#, Category:#url.category#, Code:#url.code#">

<cfoutput>
	<script>
		ptoken.navigate('Logging/CategoryWorkflowListing.cfm?category=#url.category#&code=#url.action#', 'divObservations_#url.action#');
	</script>
</cfoutput>