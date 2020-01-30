
<cfquery name="Check" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM    Ref_AreaGLedger
WHERE   Area = '#Attributes.Area#'
</cfquery>

<cfif Check.recordcount eq "0">

	<cfquery name="Insert" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		INSERT INTO Ref_AreaGLedger
		       (Area,Description,BillingEntry) 
		VALUES ('#Attributes.Area#',
		        '#Attributes.Description#',
				'#attributes.BillingEntry#')
	</cfquery>
	
<cfelse>	
	
	<cfquery name="Check" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE   Ref_AreaGLedger
		SET      Description = '#Attributes.Description#', 
		         BillingEntry = '#attributes.BillingEntry#'	 
		WHERE    Area = '#Attributes.Area#'
	</cfquery>
			
</cfif>

