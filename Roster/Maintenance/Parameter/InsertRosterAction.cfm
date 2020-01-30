
<!--- check class --->

<cfquery name="Check" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM    Ref_RosterAction
WHERE ActionCode = '#Attributes.Id#'
</cfquery>

<cfif Check.recordcount eq "0">

	<cfquery name="Insert" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO Ref_RosterAction
	       (ActionCode, ActionDescription) 
	VALUES ('#Attributes.Id#',
	        '#Attributes.Description#')
	</cfquery>
	
</cfif>

