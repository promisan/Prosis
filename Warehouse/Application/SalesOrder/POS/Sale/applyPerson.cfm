
<!--- this template 
1. adds a line to the list which it receives from the extended listing which has a form which passes
2. refreshes the listing 
--->

<!--- defined price --->

<cfquery name="setPersonNo" 
	datasource="AppsTransaction" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
	UPDATE  Sale#URL.Warehouse# 
	SET     SalesPersonNo = '#url.PersonNo#'
	WHERE   TransactionId IN (SELECT   TOP 1 TransactionId
			  				  FROM     Sale#URL.Warehouse# 
							  WHERE    CustomerId = '#url.customerid#'
							  ORDER BY Created DESC)	
	
</cfquery>	

<cfinclude template="SaleViewLines.cfm">

