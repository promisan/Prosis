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
	SELECT    *, (SELECT count(*) FROM Ref_Object WHERE ObjectUsage = L.ObjectUsage) as ObjectCount
	FROM      Ref_AllotmentVersion L
	ORDER BY  Mission,ListingOrder
</cfquery>

<cf_screentop html="No" jquery="Yes">

<table width="98%" height="100%" align="center">

<cfset Page         = "0">
<cfset add          = "1">
<cfset save         = "0"> 
<tr style="height:10px"><td><cfinclude template = "../HeaderMaintain.cfm"></td></tr>

<cfoutput>

<script>

function recordadd(grp) {
     ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width=570, height=460, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function recordedit(id1) {
     ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width=570, height=460, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

</script>	
	
</cfoutput>

<tr><td>

	<cf_divscroll>
	
	<table width="95%" align="center" class="navigation_table">
	
	<tr class="labelmedium2 line fixrow">
		    <td width="30"></td>   
			<td>Code</td>		
			<td>Description</td>
			<td>Entity/tree</td>
			<td>Class</td>
			<td>Object Usage</td>		
			<td>Registered by</td>
		    <td>On</td>	
	</tr>

	<cfoutput query="SearchResult">
		<tr class="navigation_row line labelmedium2">
			<td align="center" style="padding-top:1px">
			   <cf_img icon="open" onclick="recordedit('#Code#')" navigation="yes">	
			</td>
			<td>#Code#</td>			
			<td>#Description#</td>
			<td><cfif Mission eq "">any<cfelse>#Mission#</cfif></td>
			<td>#ProgramClass#</td>
			<td>#ObjectUsage# (#ObjectCount#)</td>			
			<td>#OfficerLastName#</td>
			<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
		</tr>	
	</cfoutput>		
	
	</table>
	
	</cf_divscroll>

</td>
</tr>
</table>