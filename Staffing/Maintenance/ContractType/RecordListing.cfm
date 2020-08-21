
<cf_screentop html="No" jquery="Yes">

<cfquery name="SearchResult"
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_ContractType
</cfquery>

<cf_divscroll>

<cfset add          = "1">
<cfset save         = "0"> 
<cfinclude template = "../HeaderMaintain.cfm"> 	

<table width="100%" align="center" cellspacing="0" cellpadding="0" >

<cfoutput>

<script LANGUAGE = "JavaScript">

function recordadd(grp) {
          window.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 600, height= 500, toolbar=no, status=yes, scrollbars=no, resizable=yes");
}

function recordedit(id1) {
          window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width= 600, height= 500, toolbar=no, status=yes, scrollbars=no, resizable=yes");
}

</script>	

</cfoutput>
	
<tr><td colspan="2">

<table width="97%" cellspacing="0" cellpadding="0" align="center" class="navigation_table">


<tr class="line labelmedium">
    <td></td>
    <td>Code</td>
	<td>Description</td>
	<td>Appointment</td>
	<td>Workflow</td>
	<td>Operational</td>
	<td>Enabled for</td>
	<td>Officer</td>
    <td>Entered</td>  
</tr>

	<cfoutput query="SearchResult">
	    <tr class="navigation_row line labelmedium" style="height:20px"> 
		<td height="18" width="5%" align="center" style="padding-top:4px">
		    <cf_img icon="open" navigation="yes" onclick="recordedit('#ContractType#');">
		</td>			
		<td>#ContractType#</td>
		<td>#Description#</td>
		<td>#AppointmentType#</td>
		<td>#EntityClass#</td>
		<td><cfif operational eq "1">Y</cfif></td>
		<td>
			<cfquery name="MissionList" 
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT 	Mission 
					FROM 	Ref_ContractTypeMission 
					WHERE 	ContractType = '#ContractType#'
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
		<td>#OfficerFirstName# #OfficerLastName#</td>
		<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
	    </tr>
	</cfoutput>
	
</table>

</td>
</tr>

</table>

</cf_divscroll>