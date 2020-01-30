
<cfquery name="Check" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM    Ref_PriceSchedule
WHERE   Code = '#Attributes.Code#'
</cfquery>

<cfif Check.recordcount eq "0">

	<cfquery name="Insert" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO Ref_PriceSchedule
	       (Code,Description) 
	VALUES ('#Attributes.Code#',
	        '#Attributes.Description#')
	</cfquery>
			
</cfif>

