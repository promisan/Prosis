
<cfquery name="Object" 
 datasource="AppsLedger"
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 	SELECT * 
	FROM   FinancialObject
	WHERE  Objectid = '#URL.ObjectId#'
</cfquery>

<cfquery name="Amount" 
 datasource="AppsLedger"
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 	SELECT   Currency, 
	         SUM(Amount) as Amount
 	FROM     FinancialObjectAmount
	WHERE    Objectid = '#URL.ObjectId#'
 	GROUP BY Currency
</cfquery>

<cfset amt = replace("#URL.Amount#",",","")>

<cfif not LSIsNumeric(amt)>

	<script>
	    alert('Invalid amount')
	</script>	 
		
<cfelse>
		
	<cfquery name="EditAmount" 
	 datasource="AppsLedger"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 UPDATE  FinancialObjectAmount
		 SET 	 Amount = '#amt#', 
		     	 AmountManual = 1  
		 WHERE 	 Objectid = '#URL.ObjectId#'
		 AND   	 SerialNo = '#URL.SerialNo#'
	</cfquery>

</cfif>

<cf_ObjectListing 
    TableWidth       = "100%"
    EntityCode       = "#Object.EntityCode#"
	ObjectReference  = "#Object.ObjectReference#"
	ObjectKey        = "#URL.Key#"
	Object           = "#URL.Obj#"
	Label            = "#URL.Lbl#"    
	Entry            = "#URL.mode#"
	Mission          = "#Object.Mission#"
	Amount           = "#Amount.Amount#" 
	Currency         = "#Amount.Currency#">	