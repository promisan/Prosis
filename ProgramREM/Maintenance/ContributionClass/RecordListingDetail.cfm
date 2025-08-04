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
	datasource="appsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT 	C.*,
				(SELECT MissionName FROM Organization.dbo.Ref_Mission WHERE Mission = C.Mission) as MissionName
		FROM 	Ref_ContributionClass C
		ORDER BY C.Mission ASC
</cfquery>

<table width="95%" align="center" class="navigation_table">

<tr class="labelmedium2 line">
	<td width="20px"></td>
    <td width="25px"></td>
    <td><cf_tl id="Class"></td>
	<td><cf_tl id="Description"></td>
	<td><cf_tl id="Mode"></td>
    <td><cf_tl id="Entered"></td>
</tr>

<cfoutput query="SearchResult" group="mission">
    
	<tr><td colspan="5" class="labelmedium2">#MissionName# <font size="-2">[#Mission#]</font></td></tr>
	
	<cfoutput>
	
	    <tr class="labelmedium2 line navigation_row"> 
			
			<td align="left" class="navigation_action" style="width:20px;padding-top:3px" onclick="recordedit('#Code#');">
				<cf_img icon="open" onclick="recordedit('#Code#');">
			</td>
			<td align="left" style="padding-top:3px;width:20px">
				<cfquery name="validate"
					datasource="appsProgram" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    SELECT 	'1'
						FROM 	Contribution
						WHERE	ContributionClass = '#Code#'
				</cfquery>

				<cfif validate.recordCount eq 0>
					<cf_img icon="delete" onclick="recordpurge('#Code#');">
				</cfif>
			</td>
			<td>#Code#</td>
			<td>#Description#</td>
			<td><cfif execution eq "0"><cf_tl id="Income"><cfelseif execution eq "1"><cf_tl id="Execution"><cfelse><cf_tl id="Income and Execution"></cfif></td>
			<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
	    </tr>
	
	</cfoutput>

</cfoutput>

</table>

<cfset AjaxOnLoad("doHighlight")>
