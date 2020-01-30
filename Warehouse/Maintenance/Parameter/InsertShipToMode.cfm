
<cfquery name="Check" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM    Ref_ShipToMode
WHERE   Code = '#Attributes.Code#'
</cfquery>

<cfif Check.recordcount eq "0">

	<cfquery name="Insert" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		INSERT INTO Ref_ShipToMode
		       (Code,Description,ListingOrder) 
		VALUES ('#Attributes.Code#',
		        '#Attributes.Description#',
				'#Attributes.ListingOrder#')
	</cfquery>
	
<cfelse>
		
	<cfquery name="Check" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE Ref_ShipToMode
		SET    ListingOrder = '#Attributes.ListingOrder#',
		       Description  = '#attributes.Description#'
		WHERE  Code = '#Attributes.Code#'
	</cfquery>
		
			
</cfif>

