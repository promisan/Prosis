
<cfoutput>

	<table height="100%" width="98%" align="center" border="0" cellspacing="0" cellpadding="0">
					
		<cfset link = "#SESSION.root#/system/organization/application/OrganizationUserList.cfm?orgunit=#Organization.Orgunit#">
				
		<tr><td valign="top" align="left" style="padding-top:3px;padding-right:20px;border-right:1px solid silver" class="labelmedium">
		
		   <cf_selectlookup
			    class    = "User"
			    box      = "user"
				title    = "Add"
				link     = "#link#"						
				dbtable  = "System.dbo.UserMission"
				des1     = "Account">
					
		</td>
						
	    <td height="100%" valign="top" width="100%" style="padding-left:4px">		
			<cf_securediv bind="url:#link#" id="user">		
		</td>
		
		</tr>  		
	
    </table>
      
</cfoutput>