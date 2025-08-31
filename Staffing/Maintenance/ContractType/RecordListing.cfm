<!--
    Copyright © 2025 Promisan B.V.

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
<cf_screentop html="No" jquery="Yes">

<cfquery name="SearchResult"
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_ContractType
</cfquery>



<cfset add          = "1">
<cfset save         = "0"> 
 	
<table width="98%" align="center" height="100%">

<tr><td style="height:10px"><cfinclude template = "../HeaderMaintain.cfm"></td></tr>

<cfoutput>

<script LANGUAGE = "JavaScript">

function recordadd(grp) {
          ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 600, height= 500, toolbar=no, status=yes, scrollbars=no, resizable=yes");
}

function recordedit(id1) {
          ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width= 600, height= 500, toolbar=no, status=yes, scrollbars=no, resizable=yes");
}

</script>	

</cfoutput>
	
<tr><td colspan="2">

<cf_divscroll>

<table width="97%" align="center" class="navigation_table">

<tr class="line labelmedium2">
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
	    <tr class="navigation_row line labelmedium2"> 
		<td height="18" width="5%" align="center" style="padding-top:2px">
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

</cf_divscroll>

</td>
</tr>

</table>

