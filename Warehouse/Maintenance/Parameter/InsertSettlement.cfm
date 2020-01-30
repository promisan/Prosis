
<cfquery name="Check" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM    Ref_Settlement
WHERE   Code = '#Attributes.Code#'
</cfquery>

<cfif Check.recordcount eq "0">

	<cfquery name="Insert" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO Ref_Settlement
	       (Code,Description,Operational,OfficerUserId,OfficerLastName,OfficerFirstName) 
	VALUES ('#Attributes.Code#',
	        '#Attributes.Description#',
			'1',
			'#SESSION.acc#',
			'#SESSION.last#',
			'#SESSION.first#')
	</cfquery>
			
</cfif>

