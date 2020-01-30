
<!--- check class --->

<cfquery name="Check" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM    Ref_SystemField
WHERE DataEntryField = '#Attributes.Field#'
</cfquery>

<cfif Check.recordcount eq "0">

	<cfquery name="Insert" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO Ref_SystemField
	       (DataEntryField,DataEntrySection,Description) 
	VALUES ('#Attributes.Field#','#Attributes.Section#','#Attributes.Description#')
	</cfquery>
	
</cfif>

