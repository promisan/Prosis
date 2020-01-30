
<!--- check class --->

<cfquery name="Check" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM    Ref_SystemAccount
WHERE Code = '#Attributes.Area#'
</cfquery>

<cfif Check.recordcount eq "0">

   <cfif attributes.operational eq "1">

	<cfquery name="Insert" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		INSERT INTO Ref_SystemAccount
		       (Code,Description,Operational) 
		VALUES ('#Attributes.Area#',
		        '#Attributes.Description#',
				'#attributes.operational#')
	</cfquery>
	
	</cfif>
	
<cfelse>

	<cfquery name="Update" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE Ref_SystemAccount
		SET    Description = '#Attributes.Description#', 
		       Operational = '#attributes.operational#'
		WHERE  Code = '#Attributes.Area#'
	</cfquery>
	
</cfif>

