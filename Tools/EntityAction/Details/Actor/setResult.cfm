

<cfquery name="Actor" 
	datasource="appsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#"> 
	SELECT      UserAccount, AccessLevel, FirstName, LastName
	FROM        OrganizationObjectActionAccess A INNER JOIN System.dbo.UserNames U ON A.UserAccount = U.Account
	WHERE       ObjectId   = '#url.ObjectId#' 
	AND         ActionCode = '#url.ActionCode#'
</cfquery>

<cfset totalyes = 0>
<cfset totalno = 0>

<cfloop query="Actor">

			<cfquery name="Process" 
				datasource="appsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#"> 
				SELECT     TOP 1 *
				FROM       OrganizationObjectActionAccessProcess
				WHERE      ObjectId     = '#ObjectId#' 
				AND        ActionCode   = '#ActionCode#'
				AND        UserAccount  = '#useraccount#'
				ORDER BY   Created DESC
			</cfquery>	
			
			<cfif Process.Decision eq "3">
			
				<CFSET totalyes = totalyes + 1>
				
			<cfelseif Process.Decision eq "9">
			
				<CFSET totalno = totalno + 1>
			
			</cfif>

</cfloop>

<cfoutput>
<table>
   <tr>
  
   <td class="labelmedium2" style="font-size:35px">#totalYes#</td>
    <td class="labelmedium2" style="padding-top:12px;font-size:20px">:<cf_tl id="Endorsed"></td>
	<td class="labelmedium2" style="padding-left:20px;font-size:35px;color:red">#totalNo#</td>
    <td class="labelmedium2" style="padding-top:12px;font-size:20px">:<cf_tl id="Not endorsed"></td>
   </tr>
</table>
</cfoutput>