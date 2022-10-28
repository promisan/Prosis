
<cfparam name="URL.ID1" default="">
<cfparam name="url.dialogHeight" default="625">

<cfparam name="url.action" default="">
<cfparam name="url.access" default="edit">

<cfif url.action eq "Insert">
	
	<cftry>
	
	   <!--- define effective date --->
	   
	   <cfquery name="Insert" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		  INSERT INTO Ref_ModuleControlUserGroup
		  (SystemFunctionId,Account,OfficerUserId,OfficerLastName,OfficerFirstName)
		  VALUES
		  ('#url.id#','#url.account#','#SESSION.acc#','#SESSION.last#','#SESSION.first#')		  
	   </cfquery>
	   
    <cfcatch></cfcatch>
	
	
		   
	</cftry>	   
	
</cfif>

<cfquery name="Group" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT DISTINCT A.*
    FROM  System.dbo.UserNames A
	WHERE A.Disabled = '0'
	AND AccountType = 'Group'
	AND A.Account NOT IN (SELECT Account 
	                     FROM System.dbo.Ref_ModuleControlUserGroup
						 WHERE SystemFunctionId = '#URL.ID#')
	<cfif SESSION.isAdministrator eq "No">  					 
	AND A.AccountOwner IN (SELECT ClassParameter
						FROM   OrganizationAuthorization A
						WHERE  A.UserAccount = '#SESSION.acc#'
						  AND  A.Role = 'AdminSystem')			 
	</cfif>					  
	ORDER BY LastName
</cfquery>

<cfquery name="Check" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT R.*
    FROM Ref_ModuleControlUserGroup R
	WHERE R.Operational = 1
	AND  SystemFunctionId = '#URL.ID#'
</cfquery>

<cfquery name="Detail" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM Ref_ModuleControlUserGroup R, UserNames U
	WHERE SystemFunctionId = '#URL.ID#'
	AND U.Account = R.Account
</cfquery>

<cfform action="#SESSION.root#/System/Modules/Functions/GroupSubmit.cfm?ID=#URL.ID#&ID1=#URL.ID1#" method="POST" enablecab="Yes" name="group">

<table width="100%" height="100%" align="center" class="navigation_table">
	    
	  <tr>
	    <td valign="center" width="100%" class="regular">
	    <table width="100%">
		
		<cfoutput>		
		
		<cfloop query="Detail">
		
		<cfset rl = Account>
		<cfset ms = AccountMission>
		<cfset op = Operational>
												
		<cfif URL.ID1 eq Account>
									
			<TR style="height:29px" class="navigation_row labelmedium2 fixlengthlist line">
					
		       <td>#AccountMission#<input type="hidden" name="Group" id="Group" value="#rl#"></td>		    					   						 						  
			   <td><a href="javascript:ShowUser('#Account#')">#Account#</a></td>
			   <td colspan="2">#LastName#</td>					   
			   <td align="center">
			      <input type="checkbox" name="Operational" id="Operational" value="1" <cfif "1" eq Operational>checked</cfif>>
			   </td>			   
			   <td colspan="2" style="padding-right:3px" align="right"><input type="submit" class="button10s" style="width:40;height:20" value="Save" ></td>

		    </TR>	
					
		<cfelse>
		
			<TR style="height:29px" bgcolor="ffffff" class="navigation_row labelmedium2 fixlengthlist line">
			   <td style="font-size:17px" height="25">#accountMission#</td>
			   <td style="font-size:17px" colspan="2">#LastName# <a href="javascript:ShowUser('#Account#')">(#rl#)</a></td>			  
			   <td align="right">#OfficerUserId# (#dateformat(created,CLIENT.DateFormatShow)#)</td>
			   <td align="center"><cfif op eq "0"><b>No</b></cfif></td>
			   <td colspan="2" align="right">
				   <table>
					   <tr>
					   <td><cf_img icon="open" navigation="Yes" onclick="ptoken.navigate('#SESSION.root#/System/Modules/Functions/Group.cfm?ID=#URL.ID#&ID1=#account#','igroup')"></td>
					   <td style="padding-left:6px;padding-right:5px;">
						 <cf_img icon="delete" onclick="ptoken.navigate('#SESSION.root#/System/Modules/Functions/GroupPurge.cfm?ID=#URL.ID#&ID1=#account#','igroup')">
					   </td>			   
					   </tr>
				   </table>
			   </td>
		    </TR>	
		
		</cfif>
				
		</cfloop>
		</cfoutput>							
												
			<tr><td height="3"></td></tr>
						
			<TR>
						 
				<td colspan="5" height="30" class="labelmedium">
				
				   <cfset link = "#SESSION.root#/system/modules/functions/Group.cfm?id=#url.id#">
				   
				   	<cf_selectlookup
				    class        = "UserGroup"
				    box          = "igroup"
					title        = "Select a user group to be granted access to this function."
					link         = "#link#"							      	
					dbtable      = "System.dbo.Ref_ModuleControlUserGroup"
					des1         = "account"
					height		 = "#url.dialogHeight#"
					icon         = "Contract.gif"
					close        = "No">
				   
				</td>				
				    
			</TR>	
				
		</table>
		
		</td>
		</tr>
				
</table>

</cfform>	

<cfset ajaxonload("doHighlight")>
	

