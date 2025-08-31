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
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   *, (SELECT count(*) 
	             FROM   ProgramAllotmentdetail 
				 WHERE  Fund IN (SELECT Code FROM Ref_Fund WHERE Fundtype = R.Code)) as Used	
	FROM     Ref_FundType R
	ORDER BY ListingOrder
</cfquery>

<cf_screentop html="No" jquery="Yes">

<table width="98%" align="center" height="100%">

<cfset Page         = "0">
<cfset add          = "1">
<cfset save         = "0"> 
<tr style="height:10px"><td><cfinclude template = "../HeaderMaintain.cfm"></td></tr>

<cfoutput>

<script>

function recordadd(grp) {
          ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 450, height= 250, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function recordedit(id1) {
          ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width= 450, height= 250, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

</script>	
	
</cfoutput>

<tr><td>

	<cf_divscroll>
	
	<table width="95%" align="center" class="navigation_table">

	<tr class="labelmedium2 line fixrow">	
	    <td></td>
	    <td>Code</td>
		<td>Description</td>
		<td>Status</td>
		<td>Order</td>
		<td>Officer</td>
	    <td>Entered</td>  
	</tr>

	<cfoutput query="SearchResult">
		<tr class="navigation_row line labelmedium2">
			<td align="center">
				<cf_img icon="open" navigation="Yes" onclick="recordedit('#Code#')">
			</td>
			<td>#Code#</a></td>
			<td>#Description#</a></td>
			<td><cfif used gte "1">In Use</cfif></td>
			<td>#ListingOrder#</td>
			<td>#OfficerFirstName# #OfficerLastName#</td>
			<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
	    </tr>
	</cfoutput>

	</table>
	
	</cf_divscroll>

</td>
</tr>
</table>
