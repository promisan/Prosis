
<!--- check class --->

<cfquery name="Check" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM    Ref_TransactionSource
	WHERE   Code = '#Attributes.Code#'
</cfquery>

<cfif Check.recordcount eq "0">

	<cfquery name="Insert" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		INSERT INTO Ref_TransactionSource 
		       (Code,Description,EditMode) 
		VALUES ('#Attributes.Code#',
		        '#Attributes.Description#', 
				'#Attributes.EditMode#')
	</cfquery>
	
<cfelse>

	<cfquery name="Update" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE Ref_TransactionSource 
		SET    Description = '#Attributes.Description#', 
		       EditMode    = '#Attributes.EditMode#'
		WHERE  Code        = '#Attributes.Code#'		
	</cfquery>	
	
</cfif>

