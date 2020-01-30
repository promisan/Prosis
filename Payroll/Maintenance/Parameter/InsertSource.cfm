
<!--- check class --->

<cfquery name="Check" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM    Ref_PayrollSource
WHERE Code = '#Attributes.Code#'
</cfquery>

<cfif Check.recordcount eq "0">

	<cfquery name="Insert" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO Ref_SlipGroup
	       (Code, Description, ListingOrder) 
	VALUES ('#Attributes.Code#',
	        '#Attributes.Description#',
			'#Attributes.ListingOrder#')
	</cfquery>
	
</cfif>

