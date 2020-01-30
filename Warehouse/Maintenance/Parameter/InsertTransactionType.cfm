
<cfquery name="Check" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM    Ref_TransactionType
WHERE   TransactionType = '#Attributes.TransactionType#'
</cfquery>

<cfif Check.recordcount eq "0">

	<cfquery name="Insert" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO Ref_TransactionType
	       (TransactionType,Description,Area) 
	VALUES ('#Attributes.TransactionType#',
	        '#Attributes.Description#',
			'#Attributes.Area#')
	</cfquery>
	
<cfelse>
	
<cfquery name="Update" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
UPDATE  Ref_TransactionType
SET     TransactionClass = '#attributes.transactionclass#',
        Description = '#attributes.Description#'
WHERE   TransactionType = '#Attributes.TransactionType#'
</cfquery>
	
			
</cfif>

