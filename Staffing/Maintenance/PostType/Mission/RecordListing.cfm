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
<cfquery name="Mission"
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

    SELECT PTMission.*, M.MissionType
	FROM   Ref_PostTypeMission PTMission
	INNER  JOIN Organization.dbo.Ref_Mission M
		   ON PTMission.Mission = M.Mission
	WHERE  PostType = '#url.posttype#'
	ORDER  BY M.MissionType
	
</cfquery>

<cfquery name="MissionToAdd"
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

    SELECT PMission.Mission, M.MissionType
	FROM   Ref_ParameterMission PMission
	INNER  JOIN Organization.dbo.Ref_MissionModule MModule
		   ON PMission.Mission = MModule.Mission AND MModule.SystemModule = 'Staffing'
	INNER  JOIN Organization.dbo.Ref_Mission M
		   ON PMission.Mission = M.Mission
	WHERE  PMission.Mission NOT IN  ( 
				  SELECT Mission
			 	  FROM   Ref_PostTypeMission
				  WHERE  PostType = '#url.posttype#'
			)
	ORDER  BY M.MissionType
	
</cfquery>

<cf_screentop height="100%" 
              scroll="Yes" 
			  banner="yellow" 
			  layout="webapp" 
			  label="PostType Mission" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<cfoutput>

<script>
	function deleteMission(mission){
		ptoken.navigate('RecordPurge.cfm?idmenu=#url.idmenu#&posttype=#url.posttype#&mission='+mission);
	}
</script>

</cfoutput>
  
<table width="90%" align="center" class="formpadding">

	<tr><td></td></tr>
	<tr class="labelmedium">
		<td width="40%"> Mission </td>
		<td> Officer </td>
		<td> Created </td>
		<td></td>
	</tr>
	
	<tr><td height="1" colspan="4" class="line"></td></tr>	
	
	<cfif MissionToAdd.recordcount gt 0>
	
		<cfform method="POST" name="posttype" action="RecordSubmit.cfm?idmenu=#url.idmenu#&posttype=#url.posttype#">
		
		<tr>
			<td align="center">
				
				<cfselect 
					name     = "Mission"
					group    = "MissionType"
					onchange = ""
					query    = "MissionToAdd"
					class    = "regularxl"
					value    = "Mission"
					display  = "Mission"/>
				
			</td>
			<td colspan="2" align="center">
				<input type="submit" class="button10g" value="Add" onclick="">
			</td>
			<td></td>
		</tr>
		
		</cfform>
		
		<tr><td coslpan="4" height="10"></td></tr>
	
	</cfif>
	
	<cfoutput query="Mission" group="MissionType">
	
		<tr class="labelmedium">
			<td colspan="4">#MissionType#</font></td>
		</tr> 
	
		<tr><td colspan="4" class="linedotted"></td></tr>
	
	  <cfoutput>
			<tr class="labelmedium linedotted">
				<td style="padding-left:12px;">#Mission#</td>
				<td>#OfficerFirstName# #OfficerLastName#</td>
				<td>#DateFormat(Created,Client.DateSQL)#</td>
				<td><cf_img icon="delete" onclick="deleteMission('#mission#')"></td>
			</tr>			
		</cfoutput>
	
	</cfoutput>

</table>
