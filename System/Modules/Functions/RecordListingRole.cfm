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
	     <tr><td colspan="3" style="background-color:##ffffaf80;" align="center" class="labelmedium2 fixlength">[<cf_tl id="No role set">]</td></tr>	
	</cfif>
				
	<cfloop query="roles">
	
	 <tr class="<cfif currentrow neq recordcount>line</cfif> labelmedium2 fixlengthlist">
		 <td class="labelit" height="17">
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