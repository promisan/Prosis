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
<cf_screentop height="100%" scroll="Yes" html="No" jquery="Yes">

<cfquery name="SearchResult"
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_AssignmentClass
	ORDER BY Listingorder 
</cfquery>

<cfset Page         = "0">
<cfset add          = "1">
<cfinclude template = "../HeaderMaintain.cfm"> 		

<cfoutput>

<script>

function recordadd() {
       ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 450, height= 280, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function recordedit(id1) {
       ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width= 450, height= 280, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

</script>	
	
</cfoutput>

<table width="95%" align="center" class="navigation_table">

<tr class="labelmedium line fixrow">
    <td></td>
    <td>Code</td>
	<td width="30%">Label</td>
	<td>Oper.</td>
	<td>Incumb</td>
	<td>Sort</td>
	<td>Officer</td>
    <td align="right" style="padding-right:3px">Entered</td>
</tr>

<cfoutput query="SearchResult">
    <tr height="20" class="navigation_row line labelmedium"> 
		<td width="5%" align="center" style="padding-top:2px">
			<cf_img icon="open" navigation="Yes" onclick="recordedit('#AssignmentClass#')">
		</td>			
		<td>#AssignmentClass#</td>
		<td>#Description#</td>
		<td><cfif operational eq "1">Yes<cfelse>No</cfif></td>
		<td>#Incumbency#%</td>
		<td>#Listingorder#</td>
		<td>#OfficerLastName#</td>
		<td align="right" style="padding-right:3px">#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
    </tr>
</cfoutput>

</table>
