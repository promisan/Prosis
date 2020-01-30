<cfquery name="MissionList" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT	M.*,
				(SELECT Mission FROM Ref_LeaveTypeMission WHERE Mission = M.Mission AND LeaveType = '#url.code#') as Selected
		FROM   	Ref_ParameterMission M	
		WHERE   Mission IN (SELECT Mission FROM Organization.dbo.Ref_MissionModule WHERE SystemModule = 'Staffing')
		ORDER BY M.Mission
</cfquery>

<cfset maxCols = 4>

<cfform action="LeaveTypeMission/RecordSubmitMission.cfm?code=#url.code#" method="POST" name="frmLeaveTypeMission">
	
	<table width="90%" align="center" class="formpadding">
	
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
					
					<td id="td_#idMission#" style="width:33%;background-color:#vColor#;" class="labelmedium">
					    <table><tr><td style="padding-left:7px">
						<input 
							type="Checkbox" 
							class="radiol"
							id="mission_#idMission#" 
							name="mission_#idMission#"
							onclick="hlMission('#idMission#', 'FBF9A8');"
							<cfif mission eq selected>checked</cfif>>
						</td>
						<td style="padding-left:4px" class="labelmedium">	
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
		<tr><td colspan="#maxCols#" class="linedotted"></td></tr>
		<tr><td height="5"></td></tr>
		<tr>	
		<td align="center" colspan="#maxCols#" height="35">
		    <input class="button10g" style="width:130px;height:25px" type="submit" name="Save" value="  Save  ">
		</td>	
		</tr>
		</cfoutput>
		
	</table>
</cfform>