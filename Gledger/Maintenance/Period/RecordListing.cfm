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

<table height="100%" width="94%" align="center" cellspacing="0" cellpadding="0" align="center">

<cfset add          = "1">
<cfset Header       = "Account Period">

<tr><td style="height:10px">
<cfinclude template = "../HeaderMaintain.cfm"> 
</td></tr>


<cfquery name="SearchResult"
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Period
</cfquery>

<cfoutput>

<script>

function recordadd(grp) {
          ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width=700, height=450, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function recordedit(id1,id2) {
          ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1 +"&ID2=" + id2, "Edit", "left=80, top=80, width=700, height= 450, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

</script>

</cfoutput>

<tr><td>

<cf_divscroll>

<table width="99%" align="center" class="navigation_table">

<thead>
<tr class="line labelmedium fixrow">
    <td></td>
    <td>Period</td>
	<td>Description</td>
	<td>Year</td>
	<td>Reconciliation<br> future periods</td>
	<td>Status</td>
	<td>Officer</td>
    <td>Entered</td>
</tr>
</thead>

<tbody>
	
	<cfoutput query="SearchResult">
	
	   	<tr class="navigation_row line labelmedium" style="height:24px">
		<td align="center" style="padding-top:1px;">
			  <cf_img icon="open" navigation="yes" onclick="recordedit('#AccountPeriod#')">
		</td>
	   	<td>#AccountPeriod#</td>
		<td>#Description#</td>
		<td>#AccountYear#</td>
		<td> <cfif Reconcile eq 1>Yes<cfelse>No</cfif></td>
		<td><cfif ActionStatus is "0">open<cfelse><b>closed</cfif></td>
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

<cfset ajaxonload("doHighlight")>
