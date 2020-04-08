<cfoutput>

<table width="100%" height="20" cellspacing="0" cellpadding="0">
			
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
	<tr><td colspan="3" class="labelit" style="padding-left:4px"><font color="gray"><cf_tl id="No role access set"></td></tr>	
	</cfif>
	
			
	<cfloop query="roles">
	
	 <tr class="line">
		 <td width="30" class="labelit" height="17" style="padding-left:3px">
		 <cfset row = row+1>#row#. 
		 </td>
		 
		 <td width="60%" class="labelit">
		 <cfif OrgUnitLevel eq "Global">
			 <a href="javascript:showrole('#role#')">#RoleDescription# [global] </a>
		 <cfelse>
		 	  #RoleDescription# [#OrgUnitLevel#]
		 </cfif>
		 </td>
		 <td width="200" class="labelit">
		 
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
	
	<cfquery name="group" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT SystemFunctionId, R.Account,LastName
		FROM   Ref_ModuleControlUserGroup R, 
		       UserNames S
		WHERE  R.Account = S.Account
		AND    R.SystemFunctionId = '#URL.Id#'
	</cfquery>
	
	<cfset crow = "0">
	
	<cfif group.recordcount eq "0">
	<tr><td colspan="3" class="labelit" style="padding-left:4px"><font color="gray">No user group access set</td></tr>	
	</cfif>
	
	<cfloop query="group">
		
	 <tr bgcolor="FFC488">
		 <td width="30" colspan="3" class="labelit" height="17" style="padding-left:3px">
		     <cfset crow = crow+1>#crow#.&nbsp;&nbsp;&nbsp;&nbsp;#LastName# 
		 </td>		 		
	 </tr>
		 
	</cfloop>	
	  	  
 </table>
 
 </cfoutput>