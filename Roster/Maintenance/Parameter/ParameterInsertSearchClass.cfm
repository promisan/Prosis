<!--- check role --->
	<cfquery name="Check" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  *
	FROM    Ref_SearchClass
	WHERE   SearchClass = '#Attributes.SearchClass#' 
	</cfquery>
	
	<cfif Check.recordcount eq "0">
	
	   <cfquery name="Insert" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO  Ref_SearchClass
		      (SearchClass, 
			   ListingOrder, 
			   ListingGroup, 
			   ListingGroupEdit, 
			   Description)
		VALUES ('#Attributes.SearchClass#',
				'#Attributes.ListingOrder#',
				'#Attributes.ListingGroup#',
				'#Attributes.ListGroupEdit#',
				'#Attributes.Description#') 
	   </cfquery>
	   
	<cfelse>
	
		<cfquery name="Check" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE  Ref_SearchClass
		SET ListingGroup = '#Attributes.ListingGroup#', Description = '#Attributes.Description#'
		WHERE   SearchClass = '#Attributes.SearchClass#' 
		</cfquery>	   
		
	</cfif>