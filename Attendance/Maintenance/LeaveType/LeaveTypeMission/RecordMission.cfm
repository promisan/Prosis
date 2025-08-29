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
<cfquery name="MissionList" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT	M.*,
				(SELECT Mission FROM Ref_LeaveTypeMission WHERE Mission = M.Mission AND LeaveType = '#url.code#') as Selected
		FROM   	Ref_ParameterMission M	
		WHERE   Mission IN (SELECT Mission FROM Organization.dbo.Ref_MissionModule WHERE SystemModule = 'Staffing')
		AND     Mission IN (SELECT Mission FROM Organization.dbo.Ref_Mission WHERE Operational = 1)
		ORDER BY M.Mission
</cfquery>

<cfset maxCols = 4>

<cf_divscroll>

<cfform action="LeaveTypeMission/RecordSubmitMission.cfm?code=#url.code#" method="POST" name="frmLeaveTypeMission">
	
	<table width="90%" align="center">
	
		<tr><td height="10"></td></tr>
		<tr>
			<cfset cnt = 0>
			<cfoutput query="MissionList">
				<cfset cnt = cnt + 1>
					<cfset vColor = "">
					<cfif mission eq selected>
						<cfset vColor = "FBF9A8">
					</cfif>
					
					<cfset idMission = replace(mission, " ", "", "ALL")>
					
					<td id="td_#idMission#" style="width:25%;background-color:#vColor#;" class="labelmedium2">
					    <table><tr><td style="padding-left:7px">
						<input 
							type="Checkbox" 
							class="radiol"
							id="mission_#idMission#" 
							name="mission_#idMission#"
							onclick="hlMission('#idMission#', 'FBF9A8');"
							<cfif mission eq selected>checked</cfif>>
						</td>
						<td style="padding-left:4px" class="labelmedium2">	
						<label for="mission_#mission#">#Mission#</label>
						</td></tr></table>
					</td>
				
				<cfif cnt eq maxCols>
					<cfset cnt = 0>
					</tr>
					<tr>
				</cfif>
			</cfoutput>
		</tr>
		
		<cfoutput>
		<tr><td height="5"></td></tr>
		<tr><td colspan="#maxCols#" class="line"></td></tr>		
		<tr>	
		<td align="center" colspan="#maxCols#" height="35">
		    <input class="button10g" style="width:180px" type="submit" name="Save" value="  Save  ">
		</td>	
		</tr>
		</cfoutput>
		
	</table>
</cfform>

</cf_divscroll>
