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
<cfset Page         = "0">
<cfset add          = "1">

<cf_screentop html="No" jquery="Yes">

<table width="98%" align="center" height="100%">

<tr style="height:10px"><td><cfinclude template = "../HeaderMaintain.cfm"></td></tr>
 
<cfquery name="SearchResult"
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM   Ref_Action 
	ORDER BY ActionSource
</cfquery>

<cfoutput>
	
	<script>
		
		function recordadd(grp) {
		    ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 570, height= 430, toolbar=no, status=yes, scrollbars=no, resizable=no");
		}
		
		function recordedit(id1) {
		    ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width= 570, height= 430, toolbar=no, status=yes, scrollbars=no, resizable=no");
		}
	
	</script>	

</cfoutput>	

<tr><td>

	<cf_divscroll>

		<table width="94%" align="center" class="navigation_table">
		
		<tr class="labelmedium2 line fixrow fixlengthlist">
		    <td>Area</td>   
			<td></td>
		    <td>Code</td>
			<td>Description</td>	
			<td>Class</td>
			<td>Workflow</td>
			<td>Mode</td>
			<td>Op.</td>
			<td>Officer</td>
		    <td>Entered</td>
		</tr>
		
		<cfset prior = "">
		
		<cfoutput query="SearchResult" group="ActionSource">
		
			<tr><td style="height:15px"></td></tr>
		
			<cfoutput>
			        
				<tr class="navigation_row line labelmedium2 fixlengthlist">			
					<td style="height:19px;font-size:16px;padding-left:4px">
					<cfif ActionSource neq prior>
						#ActionSource#
					</cfif>
					</td>				
					<td width="30" align="center" style="padding-top:1px"><cf_img icon="open" navigation="Yes" onclick="recordedit('#ActionCode#')"></td>				
					<td>#ActionCode#</td>
					<td title="#description#">#Description#</td>
					<td>#ActionClass#</td>
					<td>#EntityClass#</td>
					<td><cfif ModeEffective eq "0">Validate<cfelseif ModeEffective eq "1">Allow overlap<cfelseif ModeEffective eq "9">Disable Edit</cfif></td>
					<td><cfif operational eq "1">Yes<cfelse>No</cfif></td>
					<td>#OfficerFirstName# #OfficerLastName#</td>
					<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
			    </tr>
				
				<cfset prior = actionsource>
				
			</cfoutput>	
		
		</cfoutput>
		
		</table>

	</cf_divscroll>
	
</td>
</tr>

</table>	