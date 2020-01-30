<cfquery name="Check" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM    stStatus
WHERE Status = '#Attributes.Status#' 
AND ProgramClass = '#Attributes.ProgramClass#'
</cfquery>

<cfif Check.recordcount eq "0">

	<cfquery name="Insert" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO stStatus
	       (ProgramClass, 
		    Status, 
			Description, 
			ListingOrder, 
			Color,
			Expand)
	VALUES ('#Attributes.ProgramClass#',
	        '#Attributes.Status#',
			'#Attributes.Description#',
			'#Attributes.ListingOrder#',
			'#Attributes.Color#',
			'#Attributes.Expand#') 
	</cfquery>
	
</cfif>
