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
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_ScheduleClass
	Order by ListingOrder
</cfquery>

<cfset Page         = "0">
<cfset add          = "1">
<cfset save         = "0"> 

<cf_screentop html="No" jquery="Yes">

<table width="98%" align="center" height="100%">

<tr style="height:10px"><td><cfinclude template = "../HeaderMaintain.cfm"></td></tr>

<cfoutput>

	<script>
		
		function recordadd(grp) {
		     ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width=490, height=250, toolbar=no, status=yes, scrollbars=no, resizable=no");
		}
		
		function recordedit(id1) {
		     ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width=490, height=250, toolbar=no, status=yes, scrollbars=no, resizable=no");
		}
	
	</script>	

</cfoutput>	

<tr><td>
	
	<cf_divscroll>
	
	<table width="94%" align="center" class="navigation_table">
	
	<thead>
		<tr class="line labelmedium2">
		    <td></td> 
		    <td>Code</td>
			<td>Description</td>
			<td>Sort</td>
			<td>Officer</td>
		</tr>
	</thead>
	
	<tbody>
		<cfoutput query="SearchResult">
		    <tr height="20" class="navigation_row line labelmedium2">
				<td width="5%" align="center"><cf_img navigation="Yes" icon="open" onclick="recordedit('#Code#')"> </td>		
				<td>#Code#</td>
				<td>#Description#</td>
				<td>#ListingOrder#</td>
				<td>#OfficerFirstName# #OfficerLastName#</td>
		    </tr>
		</cfoutput>
	</tbody>	
	
	</table>
	
	</cf_divscroll>

</td></tr>

</table?