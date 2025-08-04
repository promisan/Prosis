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
<cfquery name="Mission" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT DISTINCT Mission
	FROM   Ref_MissionModule
	WHERE  SystemModule = '#URL.SystemModule#'
</cfquery>

<table width="460" cellspacing="0" cellpadding="0">
<tr><td style="padding-top:5px;padding-bottom:5px">
<table width="460" cellspacing="0" cellpadding="0" bgcolor="ffffef" class="formpadding">
	
	<cfoutput>
	
	<cfloop query = "Mission">
	
		<tr>
						
			<td width="120" class="labelit" style="padding-left:4px;padding-right:10px">
				#Mission#:
			</td>
			
			<td width="250">
				<cfquery name="MissionModule" 
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT *
					FROM   Ref_MissionModule
					WHERE  Mission 	   = '#Mission#'
					AND    SystemModule = '#URL.SystemModule#'
				</cfquery>
				
				<cfset vLicenseId = MissionModule.LicenseId > 		
			
			    <input type   = "text"
			        name      = "LicenseId_#Mission##url.SystemModule#"
					id        = "LicenseId_#Mission##url.SystemModule#"
			        value     = "#vLicenseId#"
					class     = "regularh enterastab"
			        size      = "48"
			        maxlength = "40">
					
			</td>		
			<td width="100">
				<cfdiv bind = "url:ParameterSystemCheck.cfm?module=#systemmodule#&licenseid={LicenseId_#Mission##url.SystemModule#}&mission='#mission#'" 
				   id   = "box#mission##url.systemmodule#">
			</td>
			
		</tr>
	</cfloop>
	
	</cfoutput>

</table>
</td>
</tr>
</table>