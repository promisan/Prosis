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
	<cfquery name="Workgroup" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT   *
		FROM     Ref_EntityGroup
		WHERE EntityCode = 'ProcExecution'
		<!---
		AND (Owner is NULL or Owner = '#URL.Owner#')
		--->
	</cfquery>
	
	<cfif WorkGroup.recordcount gte "1">
	
	    <select name="Workgroup" id="Workgroup" class="regularxl">
	    <cfoutput query="Workgroup">
		<option value="#EntityGroup#">#EntityGroupName#</option>
		</cfoutput>
	    </select>
			
	<cfelse>
	
		<script>
		 document.getElementById("group").className = "hide"
		</script>
								
		<input type="hidden" name="workgroup" id="workgroup" value="">		
		<font size="1">Workgroups were not configured</font>	
		
	</cfif>		