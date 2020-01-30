<cfoutput>

<table width="98%" border="0" cellspacing="0" align="center" cellpadding="0" class="formpadding">						
	<tr><td height="6"></td></tr> 
	<TR>
	<TD width="30%">Delegate From:</TD>
	<TD>
	<cfif GetAction.ActionAccess neq "">
		
		<cfquery name="Access" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT *
			FROM   Ref_EntityAction
			WHERE  EntityCode = '#URL.EntityCode#'
			AND    Operational = '1' 
			AND    ActionCode = '#GetAction.ActionAccess#'			
			</cfquery>				

		#Access.ActionCode# #Access.ActionDescription#
		
	</cfif>		
	</td>
	</tr>					
	<tr>
	<td>Limit Delegation to:&nbsp;</td>		
	<td>					
	<cfif GetAction.ActionAccessUserGroup neq "">
		
		<cfquery name="Group" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT *
			FROM Usernames
			WHERE AccountType = 'Group'		
			AND Account = '#GetAction.ActionAccessUserGroup#'			
			</cfquery>
		
		#Group.Account#
	
	</cfif>
	</td>										
	</tr>
									
	<cfif Entity.PersonClass neq "">								
		<tr>
	    <td class="labelit">Allow <cfoutput>#Entity.PersonReference#&nbsp;to perform&nbsp;this&nbsp;step:</cfoutput></td>
		<TD>						
			<cfif GetAction.PersonAccess eq "1">Yes<cfelse>No</cfif>								   
		</td>
		</tr>			
	</cfif>			
</table>
	
</cfoutput>		
	