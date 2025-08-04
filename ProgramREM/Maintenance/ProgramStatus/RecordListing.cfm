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
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_ProgramStatus
	ORDER BY StatusClass
</cfquery>



<cf_screentop html="No" jquery="Yes">

<table width="98%" height="100%" align="center">

<cfset Header       = "Text Areas">
<cfset add          = "1">
<cfset save         = "0"> 
<tr><td style="height:10px"><cfinclude template = "../HeaderMaintain.cfm"></td></tr>
 
 
<cfoutput>
 
<script>

function recordadd(grp) {
     ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 450, height= 270, toolbar=no, status=no, scrollbars=no, resizable=no");
}

function recordedit(id1) {
     ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width= 450, height= 270, toolbar=no, status=no, scrollbars=no, resizable=no");
}

</script>	

</cfoutput>

<tr><td style="height:100%">

	<cf_divscroll>
	
	<table width="95%" align="center" class="navigation_table">

		<tr class="labelmedium2 fixrow">	
		    <td>Class</td>
			<td></td>
		    <td>Code</td>
			<td>Description</td>
			<td>Officer</td>
		    <td>Entered</td>
		</tr>

		<cfoutput query="SearchResult" group="statusClass">
	    
		<tr><td colspan="5" style="height:40px" class="labellarge">#StatusClass#</td></tr>
		
		<cfoutput>
		<tr class="labelmedium2 line navigation_row">
			<td></td>
			<td align="center" style="padding-top:3px">
				<cf_img icon="select" onclick="recordedit('#Code#')" navigation="yes">
			</td>
			<td>#Code#</td>
			<td>#Description#</td>
			<td>#OfficerFirstName# #OfficerLastName#</td>
			<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
	    </tr>
		</cfoutput>
	
		</cfoutput>
				
	</table>
	
	</cf_divscroll>

</td>
</tr>
</table>
