
<!--- check class --->

<cfquery name="Check" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM    Ref_TransactionCategory
WHERE TransactionCategory = '#Attributes.TransactionCategory#'
</cfquery>

<cfif Check.recordcount eq "0">

	<cfquery name="Insert" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO Ref_TransactionCategory
	       (TransactionCategory,Description) 
	VALUES ('#Attributes.TransactionCategory#','#Attributes.Description#')
	</cfquery>
	
</cfif>

