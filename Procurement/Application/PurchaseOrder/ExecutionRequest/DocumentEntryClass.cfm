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
	<cfquery name="Class" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   DISTINCT R.*
		FROM     Ref_EntityClassPublish P, Ref_EntityClass R
		WHERE    R.EntityCode = 'ProcExecution'
		AND      P.EntityCode = R.EntityCode
		AND      P.EntityClass = R.EntityClass
		<!---
		AND     (R.EntityClassOwner is NULL or R.EntityClassOwner = '#URL.Owner#')
		--->
	</cfquery>

	<cfif Class.recordcount gte "1">
	
	    <select name="EntityClass" id="EntityClass" class="regularxl">
	    <cfoutput query="Class">
		<option value="#EntityClass#">#EntityClassName#</option>
		</cfoutput>
	    </select>
		
		<script>
		 try {
		 document.getElementById("save").className = "regular"
		 } catch(e) {}
		</script>
		
	<cfelse>
	
		<script>
		 try {
		 document.getElementById("save").className = "hide"
		 } catch(e) {}
		</script>
	
	    <font size="1" color="FF0000">Workflow not configured</font>	
	
	</cfif>	