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
<cfquery name="GetMissions" 
	datasource="appsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	M.*,
				(SELECT Mission FROM Ref_AddressTypeMission WHERE Code = '#url.id1#' and Mission = M.Mission) as Selected
		FROM 	Ref_Mission M
		WHERE   Mission IN (SELECT Mission FROM Ref_MissionModule WHERE SystemModule = 'Staffing')
		ORDER BY MissionType ASC
</cfquery>

<table width="100%" align="center">

	<tr><td height="5"></td></tr>
	<cfset maxCols = 5>
	<cfoutput query="GetMissions" group="MissionType">
		<tr>
			<td colspan="2" class="labellarge">#ucase(MissionType)#</b></td>
		</tr>
		<tr><td colspan="2" class="line"></td></tr>
		<tr>
			<td width="10"></td>
			<td>
				<table width="100%" align="center">
					<tr>
						<cfset cnt = 0>
						<cfoutput>
							<cfset cnt = cnt + 1>
							
							<cfset vStyle = "">
							<cfif mission eq selected>
								<cfset vStyle = "background-color:F2BB99;">
							</cfif>
							<td class="labelmedium2" width="#100/maxCols#%" style="#vStyle#" id="td_#trim(replace(mission,'-','_','ALL'))#">
								<label onclick="selectEntity('#trim(replace(mission,'-','_','ALL'))#','F2BB99');">
								<input type="Checkbox" class="radiol" name="mission_#trim(replace(mission,'-','_','ALL'))#" id="mission_#trim(replace(mission,'-','_','ALL'))#" <cfif mission eq selected>checked</cfif>> #Mission#
								</label>
							</td>
							<cfif cnt eq maxCols>
								<cfset cnt = 0>
								</tr>
								<tr>
							</cfif>
						</cfoutput>
					</tr>
				</table>
			</td>
		</tr>
		<tr><td height="5"></td></tr>
	</cfoutput>
</table>
