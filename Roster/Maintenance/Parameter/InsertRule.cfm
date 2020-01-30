
<!--- check class --->

<cfquery name="Check" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM    Ref_Rule
WHERE Code = '#Attributes.Code#'
</cfquery>

<cfif Check.recordcount eq "0">

	<cfquery name="Insert" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO Ref_Rule
	       ( Code, 
		     TriggerGroup, 
			 Description) 
	VALUES ('#Attributes.Code#',
	        '#Attributes.TriggerGroup#',
			'#Attributes.Description#')
	</cfquery>
	
<cfelse>

	<cfquery name="Insert" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE Ref_Rule
	SET Description = '#Attributes.Description#'
	WHERE Code = '#Attributes.Code#'
	</cfquery>
		
</cfif>

