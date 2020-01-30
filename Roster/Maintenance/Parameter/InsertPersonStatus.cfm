
<!--- check class --->

<cfquery name="Check" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM    Ref_PersonStatus
WHERE Code = '#Attributes.Id#'
</cfquery>

<cfif Check.recordcount eq "0">

	<cfquery name="Insert" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO Ref_PersonStatus
	       (Code, Description) 
	VALUES ('#Attributes.Id#',
	        '#Attributes.Description#')
	</cfquery>
	
</cfif>

