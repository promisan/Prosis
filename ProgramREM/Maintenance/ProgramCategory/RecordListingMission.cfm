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

<cfoutput>

<cfquery name="MissionList"
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT DISTINCT Mission
	FROM   Ref_ParameterMissionCategory
	WHERE  Category = '#Code#'
</cfquery>

<cfif MissionList.recordcount eq "0">
	
	<table width="100%"><tr class="labelmediumn2"><td>
		NO entities associated to this activity class.
	</td></tr>
	</table>

<cfelse>
	
	<table>
		<tr class="labelmedium2">
			<td>
			<cfloop query="MissionList">
			   #mission# <cfif currentrow neq recordcount>,</cfif>
			</cfloop>
			</td>
		</tr>
	</table>

</cfif>

</cfoutput>