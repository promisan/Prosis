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
<cfoutput>

<table width="100%">
			
	<cfquery name="roles" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT SystemFunctionId, 
		       Description as RoleDescription, 
			   OrgUnitLevel, 
			   R.Role, 
			   AccessLevels, 
			   AccessLevelLabelList
		FROM   Ref_ModuleControlRole R, 
			   Organization.dbo.Ref_AuthorizationRole AR
		WHERE  R.Role = AR.Role
		AND    R.SystemFunctionId = '#URL.Id#'
	</cfquery>
	
	<cfset row = "0">
	
	<cfif roles.recordcount eq "0">
	     <tr><td colspan="3" style="background-color:##ffffaf80;font-size:12px" align="center" class="labelmedium2 fixlength">[<cf_tl id="No role set">]</td></tr>	
	</cfif>
				
	<cfloop query="roles">
	
	 <tr class="<cfif currentrow neq recordcount>line</cfif> labelit fixlengthlist">
		 <td height="17">
		 <cfset row = row+1>#row#. 
		 </td>
		 
		 <td title="#RoleDescription# [#OrgUnitLevel#]">
		 
			 <cfif OrgUnitLevel eq "Global">
				 <a href="javascript:showrole('#role#')">#RoleDescription# [global] </a>
			 <cfelse>
			 	  #RoleDescription# [#OrgUnitLevel#]
			 </cfif>
			 
		 </td>
		 
		 <td>
		 
			 <cfquery name="access" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT *
					FROM   Ref_ModuleControlRoleLevel
					WHERE  SystemFunctionId = '#URL.Id#'
					AND  Role = '#Role#'
				</cfquery>
			
			 <cfset label = ListToArray(AccessLevelLabelList)>
				
			 <cfloop query="access">
			
				 <cftry>			
					#label[accesslevel+1]#<cfcatch>lvl:#accesslevel#</cfcatch>
				</cftry>
				<cfif currentrow neq recordcount>,</cfif>
					
			 </cfloop>
		 
		 </td>
		 
	 </tr>
		 
	</cfloop>	
	  	  
 </table>
 
 </cfoutput>