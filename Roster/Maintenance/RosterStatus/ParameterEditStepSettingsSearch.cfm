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
<cfquery name="AccessLevels" 
	 datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 SELECT 	*
		 FROM 		Ref_AuthorizationRole 		
		 WHERE 		Role = 'RosterClear' 
</cfquery>
	
<cfset processList = "Search">
	
<cfset totalProcessList = 2>
<cfset cntProcessList   = 0>

<cfoutput>
<table width="100%" align="center">
	
<cfloop list="#processList#" index="vProcess">
	
	<tr>
	
	<cfset cntProcessList = cntProcessList + 1>
		
		<cfset cntAccessLevelLabel = 0>
		
		<td valign="top" class="labelit">
		
		<cfset accessLabel = ListToArray(AccessLevels.accesslevelLabelList)>
		
		<cfloop index="level" from="0" to="#AccessLevels.accesslevels-1#">
												
			<cfquery name="ValidateLevel" 
				 datasource="AppsSelection"
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
					 SELECT 	*
					 FROM 		Ref_StatusCodeProcess
					 WHERE		Owner       = '#URL.Owner#'  		
					 AND   		Id          = 'Fun'
					 AND   		Status      = '#URL.Status#'
					 AND 		Role        = 'RosterClear'
					 AND		AccessLevel = '#level#'
					 AND		Process     = '#vProcess#'
			</cfquery>
				
				<input type="Checkbox" 
					name="accessLevel#vProcess#_#level#" class="radiol"
					value="#level#" 
					<cfif ValidateLevel.recordCount eq 1>checked</cfif>>
					
					#accessLabel[level+1]#											
			
		</cfloop>
		</td>
	
	</tr>
	
</cfloop>

</table>

</cfoutput>