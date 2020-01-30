
<!--- check class --->

<cfparam name="Attributes.KeyWordsMessage" default="">

<cfquery name="Check" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM    Ref_ParameterSkillParent
WHERE Code = '#Attributes.Code#'
AND Parent = '#Attributes.Parent#'
</cfquery>

<cfif Check.recordcount eq "0">

	<cfquery name="Insert" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO Ref_ParameterSkillParent
	       (Code, Parent, KeywordsMinimum, KeywordsMaximum, KeywordsMessage) 
	VALUES ('#Attributes.Code#',
	        '#Attributes.Parent#',
			'#Attributes.KeywordsMinimum#',
			'#Attributes.KeywordsMaximum#',
			'#Attributes.KeyWordsMessage#')
	</cfquery>
		
</cfif>

