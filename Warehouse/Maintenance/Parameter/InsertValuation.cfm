
<cfquery name="Check" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM    Ref_Valuation
WHERE   Code = '#Attributes.Code#'
</cfquery>

<cfif Check.recordcount eq "0">

	<cfquery name="Insert" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO Ref_Valuation
	       (Code,Description,Operational) 
	VALUES ('#Attributes.Code#',
	        '#Attributes.Description#',
			'#Attributes.Operational#')
	</cfquery>
	
<cfelse>
		
	<cfquery name="Check" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE Ref_Valuation
		SET Operational = '#Attributes.Operational#'
		WHERE   Code = '#Attributes.Code#'
	</cfquery>
		
			
</cfif>

