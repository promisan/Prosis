<cfoutput>

<table width="100%">
		
		
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
	    <tr class="labelmedium2"><td colspan="3" style="padding-left:4px">[ No user group set ]</td></tr>	
	</cfif>
	
	<cfloop query="group">
		
	 <tr class="labelmedium2" bgcolor="FFC488">
		 <td width="30" colspan="3" style="padding-left:3px">
		     <cfset crow = crow+1>#crow#.&nbsp;&nbsp;&nbsp;&nbsp;#LastName# 
		 </td>		 		
	 </tr>
		 
	</cfloop>	
	  	  
 </table>
 
 </cfoutput>