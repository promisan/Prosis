

<!--- attention : we need to likely adjust this by currency as it can be different !!!!! --->

<!--- we have to keep in mind that here we can have once invoice billed one line 
but associated to several workorders, so on 5/9/2016 I adjusted this to look at the transaction lines  --->
		
<cfquery name="Billed" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    L.Currency,
	          ISNULL(SUM(L.AmountCredit-L.AmountDebit),0) AS Total
	FROM      TransactionHeader H INNER JOIN
	          TransactionLine L ON H.Journal = L.Journal AND H.JournalSerialNo = L.JournalSerialNo
	WHERE     H.RecordStatus != '9' 
	AND       H.RecordStatus != '9'  <!--- excluded voided ---> 
	AND       L.TransactionSerialNo != '0' <!--- is the same as AND      L.Reference  != 'Receivable' --->
	AND       L.ReferenceId = '#url.workorderid#'	 
	AND       H.Reference != 'PreBilling'	
	GROUP BY  L.Currency
</cfquery>

<!--- amount sale/income ---> 

<cfquery name="BillingRecorded" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   ISNULL(SUM(L.AmountCredit-L.AmountDebit),0) AS Amount
	FROM     TransactionHeader H INNER JOIN
	         TransactionLine L ON H.Journal = L.Journal AND H.JournalSerialNo = L.JournalSerialNo
	WHERE    L.ReferenceId = '#url.workorderid#'
	AND      H.RecordStatus != '9' 
	AND      H.RecordStatus != '9'  <!--- excluded voided ---> 
	AND      L.Reference  = 'Sale'
	
	AND      H.Reference != 'PreBilling'
	
	
</cfquery>

<!--- amount shipped, I corrected this on 5/9/2016 to also include the returns  --->

<cfquery name="Shipped" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    ISNULL(SUM(S.SalesAmount),0) AS Billed
	FROM      ItemTransaction T INNER JOIN
	          ItemTransactionShipping S ON T.TransactionId = S.TransactionId
	WHERE     T.WorkOrderId = '#url.workorderid#' 
	AND       T.TransactionType = '2' 
	AND       S.ActionStatus != '9'
	AND       S.InvoiceId IS NOT NULL
</cfquery>

<!--- check if we have any billing which we no longer can connect to a shipping line --->

<cfoutput>  

 <table cellspacing="0" cellpadding="0">	
	 <tr><td align="right" style="height:20px" class="labelmedium">#Billed.currency# #numberformat(Billed.Total,",__.__")#</td></tr>	
	 <cfif abs(Shipped.billed-BillingRecorded.Amount) gt "1">
	 <tr><td align="right" style="height:20px" class="labelit"><font color="red">	 
	 <cf_tl id="not billed">: #numberformat(BillingRecorded.Amount-Shipped.billed,",.__")#</font></td></tr>	
	 </cfif>			 	
 </table>

</cfoutput> 