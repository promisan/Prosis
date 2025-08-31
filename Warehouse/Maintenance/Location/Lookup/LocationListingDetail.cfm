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
<cfoutput>

	<cfif MissionOrgUnitId neq "">
	
		<cfquery name="Unit" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT TOP 1 *
		FROM Organization
		WHERE MissionOrgUnitId = '#MissionOrgUnitId#'
		AND Mission = '#Mission#'
		ORDER BY Created 
		</cfquery>
	
		<cfset orgunit 		= "#Unit.OrgUnit#">
		<cfset orgunitname  = "#Unit.OrgUnitName#">
	
	<cfelse>
	
		<cfset orgunit     = "">
		<cfset orgunitname = "">
	
	</cfif>
	
	<tr class="labelmedium navigation_row">

	<td width="20" style="height:20px;padding-right:6px;padding-top:1px;padding-left:#indent#px">	
		<cf_img icon="select" navigation="Yes" onclick="Selected('#Location#','#LocationCode#','#LocationName#','#OrgUnit#','#OrgUnitName#','#PersonNo#','');">			
	</td>
	<td style="padding-right:5px">#LocationCode#</td>
	<TD width="60%">#LocationName#</TD>
	<td width="30%">#AddressCity#</td>
	<td align="right" style="padding-right:3px">
	
		<cfif latitude neq "" and longitude neq "">		
		   <input type="hidden" name="location_#locationcode#" id="location_#locationcode#" value="#latitude#:#longitude#">		   
		   <cf_img icon="open" onclick="openmap('location_#locationcode#')">			
		
		</cfif>
	
	</td>	
	</tr>
		  
</cfoutput>