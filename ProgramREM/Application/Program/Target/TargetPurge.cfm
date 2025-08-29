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
<cfquery name="update" 
    datasource="AppsProgram" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	
		UPDATE 	ProgramTarget
		SET		RecordStatus = '9'
		WHERE	ProgramCode  = '#url.programcode#'
		AND		Period       = '#url.period#'
		AND		Targetid     = '#url.targetid#' 
	
</cfquery>

<cfoutput>
	<script>
   	   _cf_loadingtexthtml='';	
   	   ptoken.navigate('#session.root#/ProgramREM/Application/Program/Target/TargetListing.cfm?programCode=#url.programcode#&period=#url.period#&ProgramAccess=EDIT&category=#url.category#', 'targetdetail_#url.category#')	
	</script>
</cfoutput>