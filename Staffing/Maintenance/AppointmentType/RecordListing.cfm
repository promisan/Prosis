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

<cfquery name="SearchResult"
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_AppointmentStatus
	Order by ListingOrder
</cfquery>


<cf_screentop html="No" jquery="Yes">

<table width="98%" align="center" height="100%">

<tr style="height:10px"><td><cfinclude template = "../HeaderMaintain.cfm"></td></tr>

<cfoutput>

<script language = "JavaScript">

function recordadd(grp) {
      ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width=700, height=500, toolbar=no, status=yes, scrollbars=no, resizable=yes");
}

function recordedit(id1) {
      ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width=700, height= 500, toolbar=no, status=yes, scrollbars=no, resizable=yes");
}

</script>	

</cfoutput>

<tr><td>

	<cf_divscroll>

	<table width="95%" align="center" class="navigation_table">
	
		<tr class="labelmedium2 line fixlengthlist">
		    <td></td> 
		    <td><cf_tl id="Code"></td>
			<td><cf_tl id="Description"></td>
			<td><cf_tl id="Sort"></td>
			<td>Op.</td>
			<td><cf_tl id="Enabled for"></td>		
			<td><cf_tl id="Officer"></td>
			<td><cf_tl id="Created"></td>
		</tr>
	
		<cfoutput query="SearchResult">
			
		    <tr height="20" class="labelmedium2 navigation_row line fixlengthlist">
				<td align="center" style="padding-top:1px">
				 <cf_img icon="open" navigation="Yes" onclick="recordedit('#code#')">
				</td>		
				<td>#Code#</td>
				<td>#Description#</td>
				<td>#ListingOrder#</td>
				<td>#Operational#</td>
				<td>
					<cfquery name="MissionList" 
						datasource="AppsEmployee" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT 	Mission 
							FROM 	Ref_AppointmentStatusMission 
							WHERE 	AppointmentStatus = '#code#'
					</cfquery>
					
					<cfset vMissionList = "">
					<cfloop query="MissionList">
						<cfset vMissionList = vMissionList & mission & ", ">
					</cfloop>
					<cfif vMissionList neq "">
						<cfset vMissionList = mid(vMissionList, 1, len(vMissionList)-2)>
					<cfelse>
						<cfset vMissionList = "All entities">
					</cfif>
					#vMissionList#
				</td>
				<td>#OfficerUserId#</td>
				<td>#dateformat(created,client.dateformatshow)#</td>
		    </tr>
	
		</cfoutput>
		
	</table>

	</cf_divscroll>
	
</td>
</tr>
</table>	
