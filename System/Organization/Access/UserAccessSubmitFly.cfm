<!--
    Copyright © 2025 Promisan B.V.

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
<cf_screentop html="No" label="User Role Assignment">

<cfoutput>
<table width="100%" cellspacing="0" cellpadding="0" id="progressbox">
<tr>
<td>&nbsp;</td>
<!---
<td><img src="#SESSION.root#/images/busy4s.gif" alt="" border="0"></td>
--->
<td height="4">
	<input type="text" class="regular3" name="progress" id="progress" size="50" maxlength="50">	
</td>
</tr>
</table>
</cfoutput> 

<cf_screenbottom html="No">

<cfparam name="Form.misrow" default="global">

<cfif Form.MisRow eq "0">

	<script>
	parent.ColdFusion.Window.hide('progress')
	alert("You must select one or more trees/missions for this role. Operation not allowed.")
	</script>
	<cfabort>

</cfif>

<cfquery name="Role" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_AuthorizationRole 
	WHERE  Role  = '#URL.ID#'
	</cfquery>

<!--- remove role --->
	
<cftransaction>

<cfset st = "0">

<cfloop index="cl" from="1" to="#form.row#">
			
	   <cfset classparameter = Evaluate("FORM." & "1_classparameter_" & #cl#)>
	   <cfset accesslevel    = Evaluate("FORM." & "1_accesslevel_" & #cl#)>
	   <cfset accessOld = Evaluate("FORM." & "1_accesslevel_old_" & #cl#)>
	
	   <cfif #AccessLevel# neq #accessOld#>
	   
		    <cfset st = "1">
			
			<cfquery name="RemoveEntries" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			DELETE FROM OrganizationObjectActionAccess
			WHERE ObjectId = '#URL.ID2#'
			AND   UserAccount = '#URL.acc#'
			AND   ActionCode = '#ClassParameter#'
			</cfquery>	
			
			<cfif AccessLevel neq "">
			
			<cfquery name="Insert" 
			datasource="AppsOrganization" 
			username=#SESSION.login# 
			password=#SESSION.dbpw#>
			INSERT INTO OrganizationObjectActionAccess
			(ObjectId, ActionCode, UserAccount, AccessLevel, 
				  OfficerUserId,
				  OfficerLastName,
				  OfficerFirstName,
				  Created)
			  VALUES ('#URL.ID2#', '#ClassParameter#', '#URL.ACC#', '#accesslevel#',
				  '#SESSION.acc#',
				  '#SESSION.last#', 
				  '#SESSION.first#', 
				  getDate())
			</cfquery>	
			
			</cfif>			
		  
	   </cfif> 
	    			  		
</cfloop>
		
<cfif st eq "0">
  <script>
  alert("You have not made any changes to the authorization profile.")  
  parent.Prosis.busy('no') 
  </script> 
  <cfabort>
</cfif>	

<!--- closing actions for account = user group--->	
	
<cfquery name="Check" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM  System.dbo.UserNames
WHERE Account = '#URL.ACC#'
</cfquery>

<cfif Check.AccountType eq "Group">

	<!--- 1. identify users for this group and remove access for these users for this role '#URL.ID4#' 
	 --->
	
	<cfquery name="Remove" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	DELETE FROM OrganizationObjectActionAccess
	WHERE  UserAccount IN (SELECT DISTINCT Account
							FROM  System.dbo.UserNamesGroup
							WHERE AccountGroup = '#URL.ACC#')
	  AND UserAccount != '#URL.ACC#'						
	  AND ObjectId     = '#URL.ID2#' 
	</cfquery>
			
	<!--- 2. add access for each user as granted to the role --->
	
	<cfquery name="Insert" 
	datasource="AppsOrganization" 
	username=#SESSION.login# 
	password=#SESSION.dbpw#>
	INSERT INTO OrganizationObjectActionAccess  
		         (ObjectId, 
				  ActionCode, 
				  UserAccount,
				  AccessLevel,
				  OfficerUserId,
				  OfficerLastName,
				  OfficerFirstName,
				  Created)
		  SELECT A.ObjectId, 
		         A.ActionCode, 
			     G.Account, 
	  		     A.AccessLevel, 
			     '#SESSION.acc#',
			     '#SESSION.last#', 
			     '#SESSION.first#', 
			     getDate()
		FROM OrganizationObjectActionAccess A, System.dbo.UserNamesGroup G
		WHERE A.UserAccount = '#URL.ACC#'						
	      AND ObjectId     = '#URL.ID2#'
	      AND G.AccountGroup = A.UserAccount
	</cfquery>		
	
</cfif>

</cftransaction>

<script>

	try { 		  
	   parent.parent.ProsisUI.closeWindow('userdialog')	 } 
	catch(e) {	parent.parent.window.close() }
		
</script>




