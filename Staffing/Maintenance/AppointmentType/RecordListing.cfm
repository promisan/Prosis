<!--- Create Criteria string for query from data entered thru search form --->

<HTML>

<HEAD>

<TITLE>Appointment Status</TITLE>
	
</HEAD>

<body>

<cfquery name="SearchResult"
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_AppointmentStatus
	Order by ListingOrder
</cfquery>

<cf_divscroll>

<cfset add          = "1">
<cfset save         = "0"> 
<cfinclude template = "../HeaderMaintain.cfm"> 	


<cfoutput>

<script language = "JavaScript">

function recordadd(grp) {
          window.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width=700, height=500, toolbar=no, status=yes, scrollbars=no, resizable=yes");
}

function recordedit(id1) {
          window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width=700, height= 500, toolbar=no, status=yes, scrollbars=no, resizable=yes");
}

</script>	

</cfoutput>

<table width="96%" cellspacing="0" cellpadding="0" align="center" class="navigation_table">

	<tr class="labelmedium line">
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
		
	    <tr height="20" class="labelmedium navigation_row line" style="height:20px">
			<td width="5%" align="center" style="padding-top:4px">
			 <cf_img icon="edit" navigation="Yes" onclick="recordedit('#code#')">
			</td>		
			<td style="min-width:40px"><a href="javascript:recordedit('#code#')">#Code#</a></td>
			<td width="20%">#Description#</td>
			<td width="5%">#ListingOrder#</td>
			<td width="5%">#Operational#</td>
			<td width="40%">
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
			<td width="8%" style="padding-right:3px">#OfficerUserId#</td>
			<td width="8%">#dateformat(created,client.dateformatshow)#</td>
	    </tr>

	</cfoutput>
	
</table>

</cf_divscroll>

</BODY></HTML>