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
	    <tr class="labelmedium2"><td colspan="3" align="center" class="fixlength" style=";font-size:12pxbackground-color:##ffffaf80;padding-left:4px">[ No group set ]</td></tr>	
	</cfif>
	
	<cfloop query="group">
		
	 <tr class="labelit fixlengthlist" style="height:18px;background-color:##FFC48880">
		 <td colspan="3" style="padding-left:3px">
		     <cfset crow = crow+1>#crow#.&nbsp;&nbsp;&nbsp;&nbsp;#LastName# 
		 </td>		 		
	 </tr>
		 
	</cfloop>	
	  	  
 </table>
 
 </cfoutput>