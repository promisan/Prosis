
<!--- check class --->

<cfquery name="Check" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM    Ref_SystemJournal
WHERE Area = '#Attributes.Area#'
</cfquery>

<cfif Check.recordcount eq "0">

	<cfquery name="Insert" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO Ref_SystemJournal
	       (Area,Description,SystemModule) 
	VALUES ('#Attributes.Area#','#Attributes.Description#','#Attributes.SystemModule#')
	</cfquery>
	
<cfelse>

<cfquery name="Update" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE Ref_SystemJournal
		SET    Description  = '#Attributes.Description#',
		       SystemModule = '#Attributes.SystemModule#'		     
		WHERE  Area = '#Attributes.Area#'
	</cfquery>	
	
</cfif>

