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
<cfquery name="Missions" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT 	*
    FROM 	Ref_ModuleControlRoleMission
	WHERE 	SystemFunctionId = '#URL.ID#'
	AND		Role = '#URL.role#'
	AND		Mission is not null
</cfquery>
<cfset allType = "Assign">
<cfif Missions.recordCount gt 0><cfset allType = "Remove"></cfif>

<cfoutput>

<cfif Missions.recordCount eq 0>
	<img src="#SESSION.root#/images/hierarchy_down.gif" height="12" width="12" style="cursor:pointer" alt="For all missions" border="0" onclick="javascript: showmissions('#URL.ID#','#URL.role#','#allType#')">
<cfelse>
	<img src="#SESSION.root#/images/insert5.gif" height="12" width="12" style="cursor:pointer" alt="Assigned to #Missions.recordCount# mission<cfif Missions.recordCount gt 1>s</cfif>" border="0" onclick="javascript: showmissions('#URL.ID#','#URL.role#','#allType#')">
</cfif>

</cfoutput>