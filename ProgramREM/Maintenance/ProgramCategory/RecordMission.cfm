
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

