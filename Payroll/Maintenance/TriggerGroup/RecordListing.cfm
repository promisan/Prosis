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
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT 	G.*,
				(
					SELECT 	ActionDescription
					FROM   	Organization.dbo.Ref_EntityAction
					WHERE	ActionCode = G.ReviewerActionCodeOne
				) as ReviewerActionCodeOneDescription,
				(
					SELECT 	ActionDescription
					FROM   	Organization.dbo.Ref_EntityAction
					WHERE	ActionCode = G.ReviewerActionCodeTwo
				) as ReviewerActionCodeTwoDescription
		FROM 	Ref_TriggerGroup G
</cfquery>

<cf_screentop html="No" jquery="Yes">

<table width="98%" height="100%" align="center">

<cfset Page         = "0">
<cfset add          = "0">
<cfset save         = "0">
<cfset Header       = "Salary Entitlement Trigger Groups">
 
<tr style="height:10px"><td><cfinclude template = "../HeaderPayroll.cfm"></td></tr>

<cfoutput>

	<script LANGUAGE = "JavaScript">
	
		function recordadd(grp) {}
		
		function recordedit(id1) {
			ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width=650, height=300, toolbar=no, status=yes, scrollbars=no, resizable=yes");
		}
	
	</script>	

</cfoutput>

<tr><td>

<cf_divscroll>

<table width="97%" align="center" class="navigation_table">

<tr class="labelmedium2 line">
    <td></td>
	<td><cf_tl id="Code"></td>
	<td><cf_tl id="Description"></td>
	<td><cf_tl id="Reviewer Action 1"></td>
	<td><cf_tl id="Reviewer Action 2"></td>
</tr>

<cfoutput query="SearchResult">
	<tr class="labelmedium2 navigation_row line">
		<td width="6%" align="center" style="padding-top:1px;">
			<cf_img icon="open" navigation="Yes" onclick="recordedit('#TriggerGroup#')">
		</td>	
		<td>#TriggerGroup#</td>
		<td>#Description#</td>
		<td><cfif ReviewerActionCodeOne neq ''>[#ReviewerActionCodeOne#] #ReviewerActionCodeOneDescription#</cfif></td>
		<td><cfif ReviewerActionCodeTwo neq ''>[#ReviewerActionCodeTwo#] #ReviewerActionCodeTwoDescription#</cfif></td>
	</tr>
</cfoutput>

</table>

</cf_divscroll>

</td>
</tr>
</table>
