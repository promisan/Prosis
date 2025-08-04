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
datasource="AppsCaseFile" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM  Ref_Incident
where class='Cause'
ORDER BY Code
</cfquery>

<cf_screentop html="No" jquery="Yes">

<table width="98%" height="100%">

<cfset Page         = "0">
<cfset add          = "1">
<cfset save         = "0"> 
<cfset Header       = "Cause">
<tr style="height:10px"><td><cfinclude template = "../../HeaderCaseFile.cfm"> </td></tr>

<cfoutput>

<script language = "JavaScript">

function recordadd(grp) {
          ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 500, height= 250, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function recordedit(id1) {
          ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width= 500, height= 250, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

</script>	

</cfoutput>

<tr><td>

<cf_divscroll>

<table width="97%" align="center" class="navigation_table">
	
	<thead>
		<tr class="labelmedium line">
		    <td width="5%"></td>
		    <td><cf_tl id="Code"></td>
			<td><cf_tl id="Description"></td>
			<td><cf_tl id="Officer"></td>
		    <td><cf_tl id="Entered"></td>  
		</tr>
	</thead>
	
	<tbody>
	<cfoutput query="SearchResult">
	   
		<tr class="navigation_row line labelmedium2">
			<td align="center">
			   <cf_img icon="open" onclick="recordedit('#Code#')" navigation="yes">
		    </td>
			<td>#Code#</td>
			<td>#Description#</td>
			<td>#OfficerFirstName# #OfficerLastName#</td>
			<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
	    </tr>	 
	
	</cfoutput>
	</tbody>
	
</table>

</cf_divscroll>

</td>
</tr>
</table>

