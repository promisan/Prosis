
<!--- amounts in the payment currency --->

<cfset Cat = "TRM">

<cfquery name="Category" 
datasource="appsTravelClaim" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT    *
	FROM      Ref_ClaimCategory
	WHERE     Code = '#cat#'
</cfquery>

<cfquery name="BaseSet" 
datasource="appsTravelClaim" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
INSERT INTO stExportFileLine
	(ExportNo,
	#PreserveSingleQuotes(Header0)#,
	ClaimObligated,
	PortalLineNo,
	ReferenceTVLT,
	LineIndexNo,
	#fund1#,
	LineDate,
	LineCurrency,
	LineAmount,
	LineAccountAmount)
SELECT  '#No#', 
        #PreserveSingleQuotes(Header1)#,
		LC.ClaimObligated,
		MIN(L.CostLineNo),
		'#Category.ReferenceTVLT#',
		stDetail.IndexNo,
		#fund1#,
		MIN(ClaimEvent.EventDateEffective) as Date,
		L.InvoiceCurrency, 
		SUM(LC.MatchingInvoiceAmount) AS InvoiceAmount, 
		SUM(LC.MatchingInvoiceAmount * Fd.Percentage) AS Amount
FROM    stPerson stDetail INNER JOIN
        ClaimEventIndicatorCost L INNER JOIN
        stPerson Person INNER JOIN
        Claim C ON Person.PersonNo = C.PersonNo INNER JOIN
        ClaimEvent ON C.ClaimId = ClaimEvent.ClaimId ON L.ClaimEventId = ClaimEvent.ClaimEventId ON stDetail.PersonNo = L.PersonNo INNER JOIN
        ClaimEventIndicatorCostLine LC ON L.ClaimEventId = LC.ClaimEventId AND L.IndicatorCode = LC.IndicatorCode AND 
        L.CostLineNo = LC.CostLineNo INNER JOIN
        stClaimFunding Fd ON LC.ClaimRequestId = Fd.ClaimRequestId AND LC.ClaimRequestLine = Fd.ClaimRequestLineNo	
WHERE   L.IndicatorCode = '#cat#' 
AND     C.ExportNo = '#No#'
GROUP BY Fd.ClaimRequestId,
         Fd.f_tvrq_doc_id, 
         Fd.f_tvrl_seq_num, 
		 LC.ClaimObligated,
		 Fd.seq_num,
		 C.ClaimId,
		 C.ClaimException,
		 C.PaymentMode,
		 L.InvoiceCurrency, 
         Person.IndexNo, 
		 stDetail.IndexNo,
		 C.DocumentNo, 
		 C.ClaimDate,
		 C.PaymentCurrency,
	     C.PaymentFund,
		 C.AccountPeriod,
		 #fund1#
ORDER BY C.DocumentNo	
</cfquery>	

<!--- 1. correction for non-obligated lines as fields are not needed ---> 

<!--- old code 
FROM    stPerson Person INNER JOIN
        Claim C ON Person.PersonNo = C.PersonNo INNER JOIN
        ClaimEvent ON C.ClaimId = ClaimEvent.ClaimId INNER JOIN
        ClaimEventIndicatorCost L INNER JOIN
        stClaimFunding Fd ON L.ClaimRequestId = Fd.ClaimRequestId AND L.ClaimRequestLineNo = Fd.ClaimRequestLineNo ON 
        ClaimEvent.ClaimEventId = L.ClaimEventId INNER JOIN
        stPerson stDetail ON L.PersonNo = stDetail.PersonNo		
--->

 