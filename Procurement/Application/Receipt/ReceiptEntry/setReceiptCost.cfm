
<!--- set the receipt cost fields --->

<cfparam name="url.action"     default="copy">
<cfparam name="url.receiptid"  default="">
<cfparam name="url.costid"     default="">
<cfparam name="url.price"      default="0">
<cfparam name="url.percent"    default="0">

<cfquery name="get" 
	 datasource="AppsPurchase" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 	 
	    SELECT    *
	    FROM      Receipt
		WHERE     receiptNo = '#url.receiptno#'		
</cfquery>	

<cfquery name="AdditionalCost" 
	 datasource="AppsLedger" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 	 
	    SELECT    SUM(L.AmountBaseDebit-L.AmountBaseCredit) as AmountBase
	    FROM      TransactionHeader H INNER JOIN
                  TransactionLine L ON H.Journal = L.Journal AND H.JournalSerialNo = L.JournalSerialNo INNER JOIN
                  Ref_Account R ON L.GLAccount = R.GLAccount
				   
		WHERE     H.Mission              = '#get.mission#'	
	    AND       H.TransactionSource    = 'ReceiptSeries'
	    AND       H.TransactionSourceNo  = '#get.receiptno#'										
		AND       H.TransactionSourceId is NULL
	    AND       H.ActionStatus         <> '9' 	
		AND       L.TransactionSerialNo != '0'  
		AND       R.TaxAccount           = '0'				
</cfquery>	

<cfif AdditionalCost.AmountBase neq "">

	<cfquery name="ReceiptCost" 
	 datasource="AppsPurchase" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 SELECT SUM(ReceiptAmountBaseCost) as Total
		 FROM   PurchaseLineReceipt 
		 WHERE  ReceiptNo    = '#get.ReceiptNo#'
		 AND    ActionStatus <> '9'
	</cfquery>

	<cfset ratio = AdditionalCost.AmountBase / ReceiptCost.total>
	<cfset url.price = round((url.price + (url.price * ratio))*100)/100>
	
</cfif>

<!--- remove digits, check for value to stop --->

<cfoutput>

<cfswitch expression="#url.action#">

<cfcase value="copy">
	
	<cfset val = url.price*url.percent/100>
	
	<script>
		document.getElementById('amountcalculation_#left(url.costid,8)#').value = '#url.price#'
		document.getElementById('amountcost_#left(url.costid,8)#').value        = '#numberformat(val,',.__')#'
	</script>
		
</cfcase>

<cfcase value="apply">

	<cfset val = url.price*url.percent/100>
		
	<script>				
		document.getElementById('amountcost_#left(url.costid,8)#').value        = '#numberformat(val,',.__')#'
	</script>

</cfcase>

</cfswitch>
</cfoutput>
