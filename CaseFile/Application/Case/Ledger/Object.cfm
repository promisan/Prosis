
<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">
	
	<tr><td>
	
	<cfquery name="Object" 
    datasource="AppsOrganization"
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">	
			SELECT  *
			FROM    OrganizationObject
			WHERE   ObjectKeyValue4 = '#URL.claimid#' 
			AND     Operational = 1 
	</cfquery>
	
	<cfif Object.recordcount eq "1">
	
	<cf_LedgerObject
    	ObjectId   = "#Object.ObjectId#">	
		
	</cfif>	
	
	</td>
	</tr>
	
</table>
