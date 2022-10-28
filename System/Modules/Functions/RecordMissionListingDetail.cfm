<cfoutput>

<table width="98%" align="center" align="center" class="formpadding">
<tr><td height="5"></td></tr>
<tr>
	<td class="labelmedium">
		<cfset link = "#SESSION.root#/System/Modules/Functions/RecordMission.cfm?functionId=#URL.functionId#&role=#url.Role#">
		<!--- <img src="#SESSION.root#/images/hierarchy_down.gif" height="10" width="10" style="cursor:pointer" 
			onclick="javascript: if (confirm('This action will remove all missions assigned, continue ?')) { ColdFusion.navigate('RecordMissionAssignAll.cfm?ID=#URL.functionId#&ID1=#url.role#&type=Remove','irolen') }" alt="Grant to all missions" border="0">
		<a href="javascript: if (confirm('This action will remove all missions assigned, continue ?')) { ColdFusion.navigate('RecordMissionAssignAll.cfm?ID=#URL.functionId#&ID1=#url.role#&type=Remove','irolen') }"><font color="0080FF">Grant to all missions</font></a> --->
		&nbsp;
	   <cf_selectlookup
	    class    = "Mission"
	    box      = "MissionRole"
		title    = "Add Entity"
		icon     = "insert.gif"
		link     = "#link#"								
		dbtable  = "Organization.dbo.Ref_Mission"
		des1     = "mission">
	</td>
</tr>
<tr>
	<td colspan="2"><cf_securediv bind="url:#link#" id="MissionRole"/>	</td>
</tr>
</table>
</cfoutput>