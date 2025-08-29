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
<cfparam name="url.workgroup" default="">

<cfquery name="Workgroup" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT  *
	FROM    Ref_Application
	WHERE   Owner = '#URL.Owner#'
</cfquery>


<cfif WorkGroup.recordcount gte "1">

    <select name="Workgroup" id="Workgroup"  class="regularxl" onChange="updateMission(this.value); updateGroup(document.getElementById('Mission'),this.value); updateRole(this.value);">
    <cfoutput query="Workgroup">
	<option value="#Code#" <cfif url.workgroup eq Code>selected</cfif>>#Description#</option>
	</cfoutput>
    </select>
	
	<script>
	 document.getElementById("save").className = "regular"
	</script>
	

<cfelse>

	<script>
	 document.getElementById("save").className = "hide"
	</script>
	
	<font size="2" color="FF0000">Workflow not configured</font>	
	
</cfif>		

<cfset AjaxOnLoad("initMissionRole")>