<cfquery name="set" 
	    datasource="AppsOrganization" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
		    UPDATE OrganizationObject
			SET    OrgUnit = '#url.orgunit#'
			WHERE ObjectId = '#url.objectid#'			
	</cfquery>	
	
	<cfquery name="get" 
	    datasource="AppsOrganization" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
		    SELECT * FROM Organization
			WHERE  OrgUnit = '#url.orgunit#'				
	</cfquery>	
	
	
			   