
<cfquery name="Purchase" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   Purchase
	WHERE  PurchaseNo = '#URL.PurchaseNo#' 
</cfquery>

<cftransaction>

<cfquery name="Invoice" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT * 
	FROM   Invoice
    WHERE  InvoiceId = '#URL.InvoiceId#' 
</cfquery>

<cfquery name="PO" 
    datasource="AppsPurchase" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	    SELECT    *
	    FROM      Purchase
		WHERE     PurchaseNo = '#url.PurchaseNo#'		
</cfquery>


<cfquery name="Parameter" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   Ref_ParameterMission
	WHERE  Mission = '#Invoice.Mission#' 
</cfquery>

<cfif Parameter.InvoiceRequisition eq "1"> 

		<!--- entry through interface --->
				
		<cfquery name="Clear" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    DELETE FROM InvoicePurchase
		    WHERE InvoiceId = '#URL.InvoiceId#' 
		</cfquery>

		<cfinclude template="InvoiceEntryMatchRequisition.cfm">

<cfelse>

	   <cfquery name="check" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT * FROM InvoicePurchase
			WHERE InvoiceId = '#URL.invoiceid#'
			AND   PurchaseNo = '#url.purchaseno#'
	   </cfquery>		
	   
	   <cfif check.recordcount eq "0">
	   	
			<cfquery name="InsertInvoice" 
			    datasource="AppsPurchase" 
			    username="#SESSION.login#" 
			    password="#SESSION.dbpw#">
			    INSERT INTO InvoicePurchase
					 (InvoiceId,
					  PurchaseNo,
					  AmountMatched,
					  DocumentAmountMatched,
					  OfficerUserId, 
					  OfficerLastName, 
					  OfficerFirstName) 
			  VALUES
					  ('#URL.invoiceid#', 
					   '#url.purchaseno#',
					   '0',
					  '0',
					   '#SESSION.acc#',
					   '#SESSION.last#',
				  	   '#SESSION.first#') 
			</cfquery> 
		
		</cfif>

		<!---

		<cfif PO.Currency eq Invoice.DocumentCurrency>
			 
		 	<cfset poamt = Invoice.DocumentAmount>
			
		<cfelse>
			 			
		  	 <cf_ExchangeRate DataSource="AppsPurchase" 
		                 CurrencyFrom="#Invoice.DocumentCurrency#"
						 CurrencyTo="#PO.Currency#">
			  
		  	 <cfset poamt   =  Round((poamt/exc)*100)/100>
									  
   		</cfif>

		<cfquery name="InsertInvoice" 
		    datasource="AppsPurchase" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
		    INSERT INTO InvoicePurchase
				 (InvoiceId,
				  PurchaseNo,
				  AmountMatched,
				  DocumentAmountMatched,
				  OfficerUserId, 
				  OfficerLastName, 
				  OfficerFirstName) 
		  VALUES
				  ('#URL.invoiceid#', 
				   '#url.purchaseno#',
				   '#poamt#',
				  '#Invoice.DocumentAmount#',
				   '#SESSION.acc#',
				   '#SESSION.last#',
			  	   '#SESSION.first#') 
		</cfquery> 
		
		--->
		
</cfif>		

</cftransaction>

<cfoutput>
<script>
    ColdFusion.navigate('#session.root#/Procurement/Application/Invoice/Workflow/Markdown/DocumentPurchase.cfm?invoiceid=#url.invoiceid#','purchaseresult')  
	// document.getElementById('purchasefundingbox').innerHTML = "#url.purchaseno#"
</script>
</cfoutput>




