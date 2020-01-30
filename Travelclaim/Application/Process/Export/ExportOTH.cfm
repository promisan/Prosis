
<!--- amounts in the amount claimed/invoices --->

<cfquery name="BaseSet" 
datasource="appsTravelClaim" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
INSERT INTO stExportFileLine
	(ExportNo,
	#Header0#,
	PortalLineNo,
	ClaimObligated,
	ReferenceTVLT,
	LineIndexNo,
	LineDate,
	LineDescription,
	#fund1#,
	LineCurrency,
	LineAmount,
	LineAccountAmount,
	SFTInvoiceNo,
	SFTDescription)
SELECT   #No#, 
		 #PreserveSingleQuotes(Header1)#,
		 L.CostLineNo,
         LC.ClaimObligated,
		 Cat.ReferenceTVLT,
		 PL.IndexNo, 
		 L.InvoiceDate,
		 I.Description+': '+L.InvoiceNo+' '+L.Description,
		 #Fund1#,
		 L.InvoiceCurrency, 
		 LC.MatchingInvoiceAmount, 
		 (LC.MatchingInvoiceAmount * Fd.Percentage) AS Amount,
		 L.InvoiceNo,
		 L.Description
FROM     Ref_Indicator I INNER JOIN
         ClaimEventIndicatorCost L INNER JOIN
         stPerson Person INNER JOIN
         Claim C ON Person.PersonNo = C.PersonNo INNER JOIN
         ClaimEvent ON C.ClaimId = ClaimEvent.ClaimId ON L.ClaimEventId = ClaimEvent.ClaimEventId ON I.Code = L.IndicatorCode INNER JOIN
         stPerson PL ON L.PersonNo = PL.PersonNo INNER JOIN
         Ref_ClaimCategory Cat ON I.ClaimCategory = Cat.Code AND I.ClaimCategory = Cat.Code INNER JOIN
         ClaimEventIndicatorCostLine LC ON L.ClaimEventId = LC.ClaimEventId AND L.IndicatorCode = LC.IndicatorCode AND 
         L.CostLineNo = LC.CostLineNo LEFT OUTER JOIN
         stClaimFunding Fd ON LC.ClaimRequestId = Fd.ClaimRequestId AND LC.ClaimRequestLine = Fd.ClaimRequestLineNo		 
WHERE    C.ExportNo = '#No#' 
AND      L.IndicatorCode != '#Cat#' 
AND      LC.MatchingInvoiceAmount <> 0
ORDER BY C.DocumentNo 
</cfquery>	

<!--- old 

FROM     Ref_Indicator I INNER JOIN
         ClaimEventIndicatorCost L INNER JOIN
         stPerson Person INNER JOIN
         Claim C ON Person.PersonNo = C.PersonNo INNER JOIN
         ClaimEvent ON C.ClaimId = ClaimEvent.ClaimId ON L.ClaimEventId = ClaimEvent.ClaimEventId ON I.Code = L.IndicatorCode INNER JOIN
         stPerson PL ON L.PersonNo = PL.PersonNo INNER JOIN
         Ref_ClaimCategory Cat ON I.ClaimCategory = Cat.Code AND I.ClaimCategory = Cat.Code LEFT OUTER JOIN
         stClaimFunding Fd ON L.ClaimRequestId = Fd.ClaimRequestId AND L.ClaimRequestLineNo = Fd.ClaimRequestLineNo
		 
		 --->