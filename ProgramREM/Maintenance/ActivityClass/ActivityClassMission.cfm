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