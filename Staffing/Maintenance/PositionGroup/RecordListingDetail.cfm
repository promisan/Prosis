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
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT 	*
	FROM 	Ref_Group
	WHERE	1=1
	<cfif url.pmission neq "">AND GroupCode in (SELECT GroupCode FROM Ref_GroupMission WHERE Mission = '#url.pmission#')</cfif>
</cfquery>

<table width="95%" align="center" class="navigation_table">  
 
<tr class="labelmedium2 line">
    <td></td> 
    <td>Code</td>
	<td>Domain</td>
	<td>Description</td>
	<td>Show in View</td>
	<td>Enabled to</td>
	<td>Officer</td>
    <td>Entered</td>  
</tr>

<cfoutput query="SearchResult">
	
    <tr height="20" class="navigation_row line labelmedium2">
		<td width="5%" align="center" style="padding-top:1px;">
			<cf_img icon="open" navigation="Yes" onclick="recordedit('#GroupCode#')">
		</td>		
		<td>#GroupCode#</td>
		<td>#GroupDomain#</td>
		<td>#Description#</td>
		<td><cfif ShowInView eq "1">Yes (#ShowInColor#)</cfif></td>
		
		<td style="font-size:12px">
	
			<cfquery name="Mission"
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT 	*
				FROM 	Ref_GroupMission
				WHERE 	GroupCode = '#GroupCode#'	
			</cfquery>
		
			<cfset vMission = "">
			<cfloop query="Mission">
				<cfset vMission = vMission & "#mission#, ">
			</cfloop>
			<cfif len(vMission) gt 0>
				<cfset vMission = mid(vMission, 1, len(vMission) - 2)>
			</cfif>
			
			#vMission#
		
		</td>
		
		<td>#OfficerLastName#</td>
		<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
    </tr>
	
</cfoutput>

</table>

<cfset AjaxOnLoad("doHighlight")>	

