
<!--- check class --->

<cfquery name="Check" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM    Ref_ApplicantClass
WHERE   ApplicantClassId = '#Attributes.Id#'
</cfquery>

<cfif Check.recordcount eq "0">

	<cfquery name="Insert" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO Ref_ApplicantClass
	       (ApplicantClassId, Description,Scope,OfficerUserId,OfficerLastName,OfficerFirstName) 
	VALUES ('#Attributes.Id#',
	        '#Attributes.Description#',
			'#Attributes.Scope#',
			'#SESSION.acc#',
			'#SESSION.last#',
			'#SESSION.first#')
	</cfquery>
	
</cfif>

