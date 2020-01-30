<cfoutput>

	<input type="hidden" id="orgunit" name="orgunit" value="#URL.orgunit#">

	<cfquery name="GetUnit" 
			 datasource="AppsOrganization" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			 
				SELECT *
				FROM   Organization
				WHERE  OrgUnit = '#URL.OrgUnit#'
				
	</cfquery>
	
	<cfif GetUnit.recordcount gt 0>
		#GetUnit.OrgUnitName#
	</cfif>
	
</cfoutput>