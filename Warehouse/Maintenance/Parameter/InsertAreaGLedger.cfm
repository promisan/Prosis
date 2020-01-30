
<cfquery name="Check" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM    Ref_AreaGLedger
WHERE   Area = '#Attributes.Area#'
</cfquery>

<cfif Check.recordcount eq "0">

	<cfquery name="Insert" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO Ref_AreaGLedger
	       (Area,Description,AccountClass,ListingOrder) 
	VALUES ('#Attributes.Area#',
	        '#Attributes.Description#',
			'#Attributes.AccountClass#',
			'#Attributes.Order#')
	</cfquery>
	
<cfelse>
	
	<cfquery name="Check" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE  Ref_AreaGLedger
	SET     ListingOrder = '#Attributes.Order#',
	        AccountClass = '#Attributes.AccountClass#',
			Description  = '#Attributes.Description#'
	WHERE   Area = '#Attributes.Area#'
	</cfquery>

			
</cfif>

