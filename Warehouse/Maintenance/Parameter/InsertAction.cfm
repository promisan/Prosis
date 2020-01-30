
<cfquery name="Check" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM    Ref_Action
WHERE   Code = '#Attributes.Code#'
</cfquery>

<cfif Check.recordcount eq "0">

	<cfquery name="Insert" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO Ref_Action
	       (Code,Description,OfficerUserId,OfficerLastName,OfficerFirstName) 
	VALUES ('#Attributes.Code#',
	        '#Attributes.Description#',
			'#session.acc#',
	        '#session.last#',
			'#session.first#')
	</cfquery>
			
</cfif>

