
<!--- get function --->

<cfparam name="url.account"     default="">
<cfparam name="url.profileid"   default="">

<cfquery name="Function" 
datasource="appsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   Account, 
	         LastName, 			 
			 Remarks,
			 (SELECT count(*) 
			  FROM   System.dbo.UserNamesGroup 
			  WHERE  Account = '#url.account#'
			  AND    AccountGroup = S.Account) as Member
    FROM     MissionProfileGroup M INNER JOIN System.dbo.UserNames S ON M.AccountGroup = S.Account
	WHERE    M.ProfileId = '#url.ProfileId#'	 	
	AND      S.Disabled = 0
	ORDER BY M.ListingOrder	
</cfquery>

<cfset cnt = 0>
<table>
<cfoutput query="Function">
	<cfset cnt = cnt + 1>
    <cfif cnt eq "1">
	<tr class="labelmedium2">
	</cfif>
	 <td style="width:200px">#LastName# : #Remarks#</td>
	 <td style="padding-left:20px;padding-right:20px">
	 <input type="checkbox" class="radiol" name="AccountGroup" <cfif Member gte "1">checked</cfif> value="#UserAccount#"></td>
	 <cfif cnt eq "1">
	 <cfset cnt = 0>
	</tr>
	</cfif>
</cfoutput>
</table>
