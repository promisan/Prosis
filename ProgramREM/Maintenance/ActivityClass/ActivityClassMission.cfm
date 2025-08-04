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
<cfquery name="GetMissions" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	M.*,
				(SELECT Mission FROM Ref_ActivityClassMission WHERE Code = '#url.id1#' AND Mission = M.Mission) as Selected
		FROM 	Ref_ParameterMission M
</cfquery>

<cfset cnt = 0>
<cfset cols = 3>
<table width="100%" align="center">
	<tr>
		<cfoutput query="GetMissions">
			<cfset missionId = replace(mission, " ", "", "ALL")>
			<cfset missionId = replace(missionId, "-", "", "ALL")>
			<td style="padding-right:5px;">
				<table>
					<tr>
						<td><input type="Checkbox" name="mission_#missionId#" id="mission_#missionId#" <cfif mission eq selected>checked</cfif>></td>
						<td style="padding-left:2px;"><label for="mission_#missionId#">#Mission#</label></td>
					</tr>
				</table>
			</td>
			<cfset cnt = cnt + 1>
			<cfif cnt eq cols>
				</tr>
				<tr>
				<cfset cnt = 0>
			</cfif>
		</cfoutput>
	</tr>
</table>