
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
	
		<tr class="labelmedium2 line">
		    <td></td> 
		    <td>Code</td>
			<td>Description</td>
			<td>Sort</td>
			<td>Op.</td>
			<td>Enabled for</td>		
			<td>Officer</td>
			<td>Created</td>
		</tr>
	
		<cfoutput query="SearchResult">
			
		    <tr height="20" class="labelmedium2 navigation_row line">
				<td width="5%" align="center" style="padding-top:1px">
				 <cf_img icon="open" navigation="Yes" onclick="recordedit('#code#')">
				</td>		
				<td style="min-width:40px">#Code#</td>
				<td width="20%">#Description#</td>
				<td width="5%">#ListingOrder#</td>
				<td width="5%">#Operational#</td>
				<td width="30%">
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
				<td width="18%" style="padding-right:3px">#OfficerUserId#</td>
				<td width="8%">#dateformat(created,client.dateformatshow)#</td>
		    </tr>
	
		</cfoutput>
		
	</table>

	</cf_divscroll>
	
</td>
</tr>
</table>	
