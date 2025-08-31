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

<table width="98%" align="center" height="100%">

<cfset Header = "Competency">
<tr style="height:10px"><td><cfinclude template="../HeaderRoster.cfm"></td></tr>
 
<cfquery name="SearchResult" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT CC.Description AS Category, C.*
	FROM  Ref_Competence C
	INNER JOIN Ref_CompetenceCategory CC
	ON C.CompetenceCategory = CC.Code
	ORDER BY CompetenceCategory, ListingOrder
</cfquery>

<cfoutput>

	<script language = "JavaScript">
	
	function recordadd(grp) {
          ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width=460, height= 300, toolbar=no, status=yes, scrollbars=no, resizable=no");
	}
	
	function recordedit(id1) {
          ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width= 460, height= 300, toolbar=no, status=yes, scrollbars=no, resizable=no");
	}
	
	</script>	

</cfoutput>
	
<tr><td>

<cf_divscroll>

	<table width="95%" align="center" class="navigation_table">
		
	<tr class="labelmedium2 line">
	    <td></td>
	    <td>Id</td>
		<td>Description</td>
		<td>Order</td>
		<td>Oper.</td>
		<td>Officer</td>
	    <td>Entered</td>
	</tr>
	
	<cfoutput query="SearchResult" group="Category">
		
		<tr class="line"><td colspan="7" style="height:40px font-size:20px" class="labellarge">#Category#</td></tr>
		
		<cfoutput>
		    <tr height="20px" class="labelmedium2 line navigation_row">
				<td align="center" width="35">
					  <cf_img icon="open" onclick="recordedit('#CompetenceId#')" navigation="Yes">
				</td>	
				<td>#CompetenceId#</td>
				<td>#Description#</td>
				<td>#ListingOrder#</td>
				<td><cfif Operational eq "0">No</cfif></td>
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