
<cfquery name="Invoice" 
 datasource="AppsPurchase"
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 	SELECT   DocumentAmount as Payable
 	FROM     Invoice
	WHERE    InvoiceId = '#URL.InvoiceId#' 	
</cfquery>

<cfset amt = replaceNoCase(url.amount,',',"")>

<cftransaction>
	
<cfif LSIsNumeric(amt)>
	
	<cfquery name="setAmount" 
	 datasource="AppsPurchase"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 UPDATE InvoiceFunding
		 SET 	Amount = '#amt#'
		 WHERE 	InvoiceId = '#URL.InvoiceId#'
		 AND   	FundingId = '#URL.FundingId#'
	</cfquery>
	
	<cfquery name="CheckTotal" 
	 datasource="AppsPurchase"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 	SELECT   sum(Amount) as Amount
	 	FROM     InvoiceFunding
		WHERE    InvoiceId = '#URL.InvoiceId#' 	
	</cfquery>
	
	<cfif CheckTotal.amount neq Invoice.Payable>
		
		<cfquery name="get" 
		 datasource="AppsPurchase"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			 SELECT * 
			 FROM   InvoiceFunding	 
			 WHERE 	InvoiceId  = '#URL.InvoiceId#'
			 AND   	FundingId != '#URL.FundingId#'
		</cfquery>
		
		<cfset diff = get.Amount + Invoice.Payable - CheckTotal.amount>
			
		<cfquery name="EditAmount" 
		 datasource="AppsPurchase"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			 UPDATE InvoiceFunding
			 SET 	Amount    = '#diff#'
			 WHERE 	InvoiceId = '#URL.InvoiceId#'
			 AND   	FundingId = '#get.FundingId#'
		</cfquery>
		
		<cfquery name="getLines" 
		 datasource="AppsPurchase"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			 SELECT * FROM InvoiceFunding			
			 WHERE 	InvoiceId = '#URL.InvoiceId#'			
		</cfquery>
		
		<cfquery name="CheckTotal" 
		 datasource="AppsPurchase"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
	 		SELECT   sum(Amount) as Amount
		 	FROM     InvoiceFunding
			WHERE    InvoiceId = '#URL.InvoiceId#' 	
		</cfquery>
		
		<cfloop query="getLines">
		
			<cfquery name="EditAmount" 
			 datasource="AppsPurchase"
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
				 UPDATE InvoiceFunding
				 SET 	Percentage   = Amount/#CheckTotal.Amount#,
				        OfficerUserId    = '#SESSION.acc#',
						OfficerLastName  = '#SESSION.last#',
						OfficerFirstName = '#SESSION.first#',
						OfficerActionDate = getDate()				    
				 WHERE 	InvoiceId = '#InvoiceId#'
				 AND   	FundingId = '#FundingId#'
			</cfquery>		
		
		</cfloop>
	
	</cfif>

</cfif>

</cftransaction>
	
<cfset url.id = url.invoiceid>
<cfinclude template="InvoiceMatchFunding.cfm">






		

