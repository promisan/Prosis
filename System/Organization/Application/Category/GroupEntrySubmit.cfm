
<cf_compression>

<cfif url.action eq "Delete">
	
	<cfquery name="ResetGroup" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  DELETE FROM OrganizationCategory
	  WHERE OrgUnit = '#url.OrgUnit#'
	  AND   OrganizationCategory = '#url.category#'
	</cfquery>
	
	<cfquery name="ResetPosition" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  DELETE FROM  PositionCategory
	  WHERE  PositionNo IN (SELECT PositionNo 
	                       FROM Position 
						   WHERE OrgUnitOperational   = '#url.OrgUnit#')
	  AND    OrganizationCategory = '#url.category#'
	</cfquery>

</cfif>

<cfif url.action eq "Insert">
	
	<cfquery name="InsertGroup" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		INSERT INTO OrganizationCategory 
	         (OrgUnit,
			 OrganizationCategory,
			 Status,
			 OfficerUserId,
			 OfficerLastName,
			 OfficerFirstName)
	  VALUES ('#url.OrgUnit#', 
	      	  '#url.category#',
		      '1',
			  '#SESSION.acc#',
			  '#SESSION.last#',
			  '#SESSION.first#')
	</cfquery>
	
	<cfquery name="InsertPosition" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		INSERT INTO PositionCategory 
		         (PositionNo,
				 OrganizationCategory,
				 Status,
				 OfficerUserId,
				 OfficerLastName,
				 OfficerFirstName)
		SELECT   PositionNo,
		         '#url.category#',
		         '1',
		         '#SESSION.acc#',
			     '#SESSION.last#',
			     '#SESSION.first#'
		FROM     Position P
		WHERE    OrgUnitOperational = '#url.OrgUnit#'
		AND      PositionNo NOT IN (SELECT PositionNo
		                            FROM   PositionCategory 
									WHERE  PositionNo = P.PositionNo
		                            AND    OrganizationCategory = '#url.category#')		
	</cfquery>

</cfif>
	

