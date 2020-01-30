
<!--- check class --->

<cfquery name="Check" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM    Ref_ParameterSkill
WHERE Code = '#Attributes.Code#'
</cfquery>

<cfif Check.recordcount eq "0">

	<cfquery name="Insert" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO Ref_ParameterSkill
	       (Code, ListingOrder, Description, Template, Framescrollbar, CandidateHint) 
	VALUES ('#Attributes.Code#',
	        '#Attributes.ListingOrder#',
			'#Attributes.Description#',
			'#Attributes.Template#',
			'#Attributes.Framescrollbar#',
			'#Attributes.CandidateHint#')
	</cfquery>
		
</cfif>

