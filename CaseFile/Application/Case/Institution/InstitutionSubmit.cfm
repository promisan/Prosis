
<cfquery name="Update" 
	datasource="AppsCaseFile" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE   ClaimOrganization 
	SET      OrgUnit          = '#URL.OrgUnit#',
	         OfficerLastName  = '#SESSION.last#',
			 OfficerFirstName = '#SESSION.first#',
			 Created          = getDate()
	WHERE    ClaimId          = '#URL.ClaimId#'	
	AND  	 ClaimRole        = '#URL.Role#'  
</cfquery>	

<cfinclude template="../../../../System/Organization/Application/Address/UnitAddressInfo.cfm">
		