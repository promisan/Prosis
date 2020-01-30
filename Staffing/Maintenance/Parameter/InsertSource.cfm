
<!--- check class --->

<cfquery name="Check" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM    Ref_ActionSource
WHERE ActionSource = '#Attributes.ActionSource#'
</cfquery>

<cfif Check.recordcount eq "0">

	<cfquery name="Insert" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO Ref_ActionSource
	       (ActionSource, Description) 
	VALUES ('#Attributes.ActionSource#',
	        '#Attributes.Description#')
	</cfquery>
	
</cfif>

