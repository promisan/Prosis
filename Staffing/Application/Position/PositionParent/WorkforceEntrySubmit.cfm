
<cf_compression>

<cfif url.action eq "Delete">
		
	<cfquery name="ResetPosition" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  DELETE FROM  PositionCategory
	  WHERE  PositionNo = '#url.PositionNo#'
	  AND    OrganizationCategory = '#url.category#'
	</cfquery>

</cfif>

<cfif url.action eq "Insert">

	<cfquery name="ResetPosition" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  DELETE FROM  PositionCategory
	  WHERE  PositionNo = '#url.PositionNo#'
	  AND    OrganizationCategory = '#url.category#'
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
		SELECT   '#url.positionNo#',
		         '#url.category#',
		         '1',
		         '#SESSION.acc#',
			     '#SESSION.last#',
			     '#SESSION.first#'		
	</cfquery>

</cfif>
	

