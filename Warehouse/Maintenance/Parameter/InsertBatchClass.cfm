
<cfquery name="Check" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM    Ref_WarehouseBatchClass
WHERE   Code = '#Attributes.Code#'
</cfquery>

<cfif Check.recordcount eq "0">

	<cfquery name="Insert" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO Ref_WarehouseBatchClass
	       (Code,Description) 
	VALUES ('#Attributes.Code#',
	        '#Attributes.Description#')
	</cfquery>
	
<cfelse>
		
	<cfquery name="Update" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE  Ref_WarehouseBatchClass
		SET     Description = '#attributes.Description#'
		WHERE   Code        = '#Attributes.Code#'
	</cfquery>
				
</cfif>

