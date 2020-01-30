<tr><td colspan="3" bgcolor="ffffff" valign="top">
	
	<cfoutput>
	
	<cfquery name="User" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
	    FROM UserNames
	    WHERE Account = '#SESSION.acc#'
	</cfquery>
	
	<cfquery name="Unit" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT TOP 1 *
	    FROM  UserMission U, Organization.dbo.Organization O
		WHERE U.OrgUnit = O.OrgUnit
		AND   U.Account = '#SESSION.acc#'   
	</cfquery>
		
	<cfquery name="Parent" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
    FROM  Organization 
	WHERE OrgUnitCode = '#Unit.ParentOrgUnit#'  
	AND  Mission = '#Unit.Mission#'
	AND  MandateNo = '#Unit.MandateNo#'
	</cfquery>
	
	<cfparam name="CLIENT.Category" default="">

	<!--- claim owner --->
	<table width="100%" cellspacing="0" cellpadding="0"">
		
		<tr>
		   <td>
		   <table width="97%" align="center" cellspacing="0" cellpadding="0" class="formpadding">
			   <tr>			  
				   <td height="20" width="60"><b><cf_tl id="Name">:</b></td>
				   <td>#User.FirstName# #User.LastName#</td>
				   <cfif user.PersonNo neq "">
				   <td width="100"><b><cf_tl id="Employee No">:</b></td>
				   <td>#User.PersonNo#</td>
				   <cfelse>
				   <td></td><td></td>
				   </cfif>
				   <td><b><cf_tl id="E-Mail">:</td>
				   <td>#User.EMailAddress#</td>
				   <td><b><cf_tl id="Organization">:</td>
				   <td>
				   
				   <cfif Unit.OrgUnitName eq "">Internal
				   <cfelseif Parent.OrgUnitName neq "">
				   #Parent.OrgUnitName#
				   <cfelse>			   
				   #Unit.OrgUnitName#</cfif>&nbsp;
				   </td>			  
			   </tr>
		   </table>
		   </td>
		</tr>
		
	</table>
	
	</cfoutput>
	
</td></tr>