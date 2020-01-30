
<!--- check role --->

<cfquery name="Check" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM    Ref_StatusCode
WHERE Owner = '#Attributes.Owner#'
AND   Status = '#Attributes.Status#'
AND   Id = '#Attributes.Id#'
</cfquery>

<cfif Check.recordcount eq "0">

	<cfquery name="Insert" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO StatusCode
	       (Owner, Id, Status, RosterAction, AccessLevel, Meaning, TextHeader) 
	VALUES ('#Attributes.Owner#',
	        '#Attributes.Id#',
			'#Attributes.Status#',
			'#Attributes.RosterAction#'
			'#Attributes.AccessLevel#',
			'#Attributes.Meaning#',
			'#Attributes.TextHeader#')
	</cfquery>
	
</cfif>

