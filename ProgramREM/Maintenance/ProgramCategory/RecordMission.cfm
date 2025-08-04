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

<cfparam name="url.category" default="0">

<cfquery name="MissionList" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *, (SELECT Category FROM Ref_ParameterMission WHERE Mission = L.Mission and Category = '#url.category#') as selected
FROM Ref_ParameterMission
WHERE Mission IN (SELECT Mission 
                  FROM Organization.dbo.Ref_MissionModule 
				  WHERE SystemModule = 'Program')
</cfquery>

<cf_screentop height="100%" layout="innerbox" scroll="Yes">

<table cellspacing="0" cellpadding="0" class="formpadding">

<cfoutput query="MissionList">

	<tr>
		<td>#Mission#</td>
		<td><input type="checkbox" name="missionselect" value="#mission#" <cfif selected neq "">checked</cfif>></td>
	</tr>

</cfoutput>

</table>

<cf_screenbottom layout="innerbox">

