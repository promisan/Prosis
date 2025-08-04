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
<!--- Create Criteria string for query from data entered thru search form --->

<cf_screentop html="No" jquery="Yes">

<table width="98%" height="100%" border="0" cellspacing="0" cellpadding="0" align="center">

<cfset add          = "1">
<cfset save         = "0"> 
<tr style="height:10px"><td><cfinclude template = "../HeaderMaintain.cfm"></td></tr>


<cfquery name="SearchResult"
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT 	C.*,
				ISNULL((SELECT ISNULL(COUNT(*),0) FROM Ref_ActivityClassMission WHERE Code = C.Code),0) as CountMissions
		FROM 	Ref_ActivityClass C
</cfquery>



<cfoutput>

<script>

function recordadd(grp) {
     ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 560, height= 400, toolbar=no, status=yes, scrollbars=no, resizable=yes");
}

function recordedit(id1) {
     ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width=560, height=400, toolbar=no, status=yes, scrollbars=no, resizable=yes");
}

</script>	

</cfoutput>

<tr><td>
	
	<cf_divscroll>
	
		<table width="96%" align="center" class="navigation_table">
		
		<thead>
			<tr class="labelmedium2 fixrow line">
			    <td></td>
			    <td>Code</td>
				<td>Description</td>
				<td align="center">Entities</td>
				<td>Officer</td>
			    <td>Entered</td>
			</tr>
		</thead>
		
		<tbody>
		<cfoutput query="SearchResult">
		     
			<tr height="20" class="navigation_row labelmedium2 line">
				<td align="center" style="padding-top:3px;">
				  <cf_img icon="open" onclick="recordedit('#Code#');" navigation="Yes">
				</td>
				<td><a href="javascript:recordedit('#Code#')">#Code#</a></td>
				<td>#Description#</td>
				<td align="center">#CountMissions#</td>
				<td>#OfficerFirstName# #OfficerLastName#</td>
				<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
		    </tr>
			
		</cfoutput>
		</tbody>
		
		</table>
	
	</cf_divscroll>

</td></tr></table>
