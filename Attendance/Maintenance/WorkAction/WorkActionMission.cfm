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
<cfoutput>
	<table width="100%" align="center">
		<tr class="labelmedium">
			<td width="5%">
				<a href="javascript:addMission('#url.id1#')">
					<cf_tl id="add">
				</a>
			</td>
			<td width="3">&nbsp;</td>
			<td class="labelmedium">
				<cfquery name="missionlist"
					datasource="appsEmployee" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    SELECT 	*
						FROM 	Ref_WorkActionMission
						WHERE	ActionClass = '#url.id1#'
				</cfquery>
				
				<cfset vMissionList = "">
				
				<cfloop query="missionList">
					<cfset vMissionList = vMissionList & mission & ", ">
				</cfloop>
				
				<cfif vMissionList neq "">
					<cfset vMissionList = mid(vMissionList, 1, len(vMissionList) - 2)>
					#vMissionList#
				<cfelse>
					<font color="BFBFBF">
						[<cf_tl id="No entities selected">]
					</font>
				</cfif>
				
			</td>
		</tr>
	</table>
</cfoutput>