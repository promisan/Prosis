
<!--- check class --->

<cfquery name="Check" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM    Ref_TransactionType
WHERE   TransactionCategory = '#Attributes.TransactionCategory#'
AND     TransactionType = '#Attributes.TransactionType#'
</cfquery>

<cfif Check.recordcount eq "0">

	<cfquery name="Insert" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO Ref_TransactionType
	       (TransactionCategory,TransactionType) 
	VALUES ('#Attributes.TransactionCategory#','#Attributes.TransactionType#')
	</cfquery>
			
</cfif>

