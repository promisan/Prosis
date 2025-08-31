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
<cfquery name="SearchResult"
datasource="appsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT 	*
	FROM 	Ref_Designation
	ORDER BY ListingOrder
</cfquery>

<cf_screentop html="No" jquery="Yes">

<table width="98%" height="100%" align="center">

<cfset Page         = "0">
<cfset add          = "1">
<cfset save         = "0">
<cfset Header       = "Designation">
 
<tr style="height:10px"><td><cfinclude template = "../HeaderPayroll.cfm"></td></tr>
 
 <cfoutput>

<script>

function recordadd(grp) {
          ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 460, height= 250, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function recordedit(id1) {
          ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width= 460, height= 250, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

</script>	

</cfoutput>

<tr><td>

<cf_divscroll>

	<table width="96%"  align="center" class="navigation_table">
	
	<thead>
	<tr class="labelmedium2 line">
	    <td width="30"></td>
		<td align="center" width="70">Order</td>
	    <td>Code</td>
		<td>Description</td>
		<td>Officer</td>
	    <td>Entered</td>
	</tr>
	</thead>
	
	<tbody>
	<cfoutput query="SearchResult">
	    <tr class="navigation_row line labelmedium2"> 
			<td align="center">
				<cf_img icon="open" navigation="Yes" onclick="recordedit('#Code#')">
			</td>
			<td align="center">#listingOrder#</td>
			<td>#Code#</td>
			<td>#Description#</td>
			<td>#OfficerFirstName# #OfficerLastName#</td>
			<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
	    </tr>
	</cfoutput>
	</tbody>
	
	</table>

</cf_divscroll>

</td></tr>

</table>
