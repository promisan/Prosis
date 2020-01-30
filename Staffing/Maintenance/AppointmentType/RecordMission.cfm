<cfquery name="MissionList" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT	M.*,
				(SELECT Mission FROM Ref_AppointmentStatusMission WHERE Mission = M.Mission AND AppointmentStatus = '#url.code#') as Selected
		FROM   	Ref_ParameterMission M	
		WHERE   Mission IN (SELECT Mission FROM Organization.dbo.Ref_Mission WHERE Operational = 1)
		ORDER BY M.Mission
</cfquery>

<cfset maxCols = 4>
<cfset cnt = 0>

<table width="100%" cellspacing="0" cellpadding="0" align="center">
	<tr>
		<cfoutput query="MissionList">
		
				<cfset cnt = cnt + 1>
				<cfset vColor = "">
				<cfif mission eq selected>
					<cfset vColor = "FBF9A8">
				</cfif>
				
				<cfset idMission = replace(mission, " ", "", "ALL")>
				<cfset idMission = replace(idmission, "-", "", "ALL")>
				<cfset idMission = replace(idmission, "&", "", "ALL")>
				<cfset idMission = replace(idmission, ".", "", "ALL")>
				
				<td id="td_#idMission#" style="padding-left:5px;background-color:#vColor#;" class="labelmedium">
							
					<input type="Checkbox" id="mission_#idMission#" name="mission_#idMission#" onclick="hlMission('#idMission#', 'FBF9A8');" <cfif mission eq selected>checked</cfif>>
					<label for="mission_#mission#">#Mission#</label>
					
				</td>
			
				<cfif cnt eq maxCols>
					<cfset cnt = 0>
					</tr>
					<tr>
				</cfif>
			
		</cfoutput>
	</tr>
	
</table>