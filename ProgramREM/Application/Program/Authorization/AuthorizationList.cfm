
<cfquery name="User" 
   datasource="AppsProgram" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	SELECT  DISTINCT F.*, E.*
	FROM    ProgramAccessAuthorization F, System.dbo.UserNames E
	WHERE   F.ProgramCode  =  '#url.ProgramCode#'
	AND     F.UserAccount  =  E.Account
 	AND     F.Role         = '#URL.Role#' 
</cfquery>
	
<table width="99%" align="center" border="0" cellspacing="0" cellpadding="0" class="navigation_table">			
  
   <cfif User.recordcount eq "0">
   
   <tr>
    <td colspan="6" align="center" style="height:20px" class="labelit"><font color="red">No records to show in this view</td>
   </tr>
  
   <cfelse>
   
    <tr>
	   <td width="2%"></td>
       <td width="10%" height="15" class="labelit">IndexNo </td>
	   <TD width="30%" height="15" class="labelit">Name</TD>
	   <TD width="5%" height="15" class="labelit">S</TD>
	   <TD width="10%" height="15" class="labelit">Account</TD>
	   <!---
	   <td width="20%" width="20%" class="labelit" height="15">Role</td>  
	   --->
	   <td></td>   
   </TR>
   			   
   <cfoutput query="User">
   
   <tr><td colspan="7" class="linedotted"></td></tr>
   <tr class="navigation_row">
   	  <td class="labelsmall" height="20" style="padding-left;2px">#currentrow#.</td>
      <td class="labelit">#IndexNo#</td>
	  <td class="labelit">#FirstName# #LastName#</td>
	  <td class="labelit">#Gender#</td>
	  <td class="labelit">#Account#</td>
	  <!---
	  <td class="labelit">#Role#</td>
	  --->
	  <td align="right" style="padding-right:10px">
	    <cfif url.mode eq "edit">
	    <cf_img icon="delete" navigation="Yes" onclick="_cf_loadingtexthtml='';ColdFusion.navigate('#SESSION.root#/ProgramREM/application/Program/Authorization/AuthorizationAccess.cfm?action=delete&ProgramCode=#URL.ProgramCode#&Role=#url.role#&Account=#UserAccount#','#url.role#')">		
		</cfif>
	  </td>
   </tr> 
     	  
    </CFOUTPUT>   
	
	</cfif>
   
</table>

<cfset AjaxOnLoad("doHighlight")>	   