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
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_Source
</cfquery>


<cf_screentop html="No" jquery="Yes">

<cfset Page         = "0">
<cfset add          = "1">

<table height="100%" width="99%" align="center">

<tr><td style="height:10px"><cfinclude template = "../HeaderMaintain.cfm"></td></tr>

<cfset Page         = "0">
<cfset add          = "1">
<cfinclude template = "../HeaderMaintain.cfm"> 	

<cfoutput>

<script>

function recordadd(grp) {
          ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 450, height= 220, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function recordedit(id1) {
          ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width= 450, height= 220, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

</script>

</cfoutput> 
	
<!--- "width=550, height=500, scrollbars=yes, resizable=yes" --->

<tr><td colspan="2">

	<cf_divscroll>
	
	<table align="center" width="97%" class="navigation_table">
	
	<tr class="labelmedium2">
	    <td></td>
	    <td>Code</td>
		<td>Description</td>
		<td>Officer</td>
	    <td>Entered</td>
	</tr>
	
	<cfoutput query="SearchResult">
	 		
	    <tr class="navigation_row line labelmedium2"> 
			<td align="center" style="padding-top:0px">
			   <cf_img icon="open" navigation="yes" onclick="recordedit('#Code#');">
			</td>
			<td>#Code#</td>
			<td>#Description#</td>
			<td>#OfficerFirstName# #OfficerLastName#</td>
			<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
			
	    </tr>
			
	</CFOUTPUT>
	
	</table>
	
	</cf_divscroll>
	
	</td>
</tr>

</table>

