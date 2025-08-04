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
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_Relationship
</cfquery>

<cf_screentop height="100%" scroll="Yes" html="No" jquery="Yes">
<cf_divscroll>

<cfset add          = "1">
<cfinclude template = "../HeaderMaintain.cfm"> 

<cfoutput>

<script language = "JavaScript">

	function recordadd(grp) {
	       ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 490, height= 250, toolbar=no, status=yes, scrollbars=no, resizable=no");
	}
	
	function recordedit(id1) {
	       ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width= 490, height= 250, toolbar=no, status=yes, scrollbars=no, resizable=no");
	}

</script>	

</cfoutput>

<table width="96%" align="center" class="navigation_table">

<thead>
	<tr class="labelmedium line">
	    <td></td> 
	    <td>Code</td>
		<td>Descriptive</td>
		<td>Officer</td>
	    <td>Entered</td>
	</tr>
</thead>

<tbody>
	<cfoutput query="SearchResult">
	
	    <tr class="navigation_row labelmedium2 line"> 
			<td width="5%" align="center" style="padding-top:1px;"> 
			 <cf_img icon="open" navigation="Yes" onclick="recordedit('#Relationship#')">
			</td>		
			<td width="20%">#Relationship#</td>
			<td width="40%">#Description#</td>
			<td>#OfficerFirstName# #OfficerLastName#</td>
			<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
	    </tr>
	
	</cfoutput>
</tbody>

</table>

</cf_divscroll>
