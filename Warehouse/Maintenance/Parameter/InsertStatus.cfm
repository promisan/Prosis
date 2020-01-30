
<cfquery name="Check" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM    Status
WHERE   Class = '#Attributes.Class#'
AND     Status = '#Attributes.Status#'
</cfquery>

<cfif Check.recordcount eq "0">

	<cfquery name="Insert" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO Status
	       (Class,Status,Listingorder,Description,Description2,Show) 
	VALUES ('#Attributes.Class#',
	        '#Attributes.Status#',
			'#Attributes.ListingOrder#',
	        '#Attributes.Description#',
			'#Attributes.Description2#',
			'1')
	</cfquery>
			
</cfif>

