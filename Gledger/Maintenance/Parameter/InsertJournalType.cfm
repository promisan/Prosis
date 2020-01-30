
<!--- check class --->

<cfquery name="Check" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM    Ref_JournalType
WHERE JournalType = '#Attributes.JournalType#'
</cfquery>

<cfif Check.recordcount eq "0">

	<cfquery name="Insert" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO Ref_JournalType
	       (JournalType,Description) 
	VALUES ('#Attributes.JournalType#','#Attributes.Description#')
	</cfquery>
	
</cfif>

