
<!--- this template 
1. adds a line to the list which it receives from the extended listing which has a form which passes
2. refreshes the listing 
--->

<!--- defined price --->

<cfquery name="setPersonNo" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
	UPDATE  CustomerRequestLine 
	SET     SalesPersonNo = '#url.PersonNo#'
	WHERE   TransactionId IN (SELECT   TOP 1 TransactionId
			  				  FROM     CustomerRequestLine 
							  WHERE    RequestNo = '#url.RequestNo#'
							  ORDER BY Created DESC)	
	
</cfquery>	

<cfinclude template="SaleViewLines.cfm">

