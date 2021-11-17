

<cfquery name="Check"
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT       TOP 100 PERCENT Line.Journal, 
	             Line.JournalSerialNo, 
				 ROUND(SUM(Line.AmountBaseDebit), 2) AS Debit, 
				 ROUND(SUM(Line.AmountBaseCredit), 2) AS Credit, 
	             HDR.Mission, HDR.Description, HDR.TransactionSource, HDR.Reference, HDR.ReferenceName, HDR.AccountPeriod, HDR.TransactionDate, HDR.JournalBatchDate, 
	             HDR.DocumentDate, HDR.ReferenceNo, HDR.ReferenceId, HDR.Created, HDR.DocumentCurrency, HDR.DocumentAmount
				 
	FROM         TransactionLine Line INNER JOIN
	             TransactionHeader HDR ON Line.Journal = HDR.Journal AND Line.JournalSerialNo = HDR.JournalSerialNo
	WHERE        HDR.Mission       = '#url.mission#'
	AND          HDR.AccountPeriod = '#url.period#'
			   
	GROUP BY     Line.Journal, 
	             Line.JournalSerialNo, 
			     HDR.Mission, 
			     HDR.Description, 
				 HDR.AccountPeriod, 
				 HDR.JournalBatchDate, 
				 HDR.DocumentDate, 
				 HDR.ReferenceNo, 
		         HDR.ReferenceId, 
				 HDR.Created, 
				 HDR.TransactionDate, 
				 HDR.TransactionSource, 
				 HDR.Reference, 
				 HDR.ReferenceName, 
				 HDR.DocumentCurrency, 
		         HDR.DocumentAmount
				 
	HAVING       (ABS(ROUND(SUM(Line.AmountBaseDebit) - SUM(Line.AmountBaseCredit), 2)) > 0.5)
	
	ORDER BY HDR.TransactionDate DESC, HDR.Created DESC
</cfquery>

<cfif check.recordcount gte "3">
	<tr>
	  <td colspan="3" style="height:30px" class="labelmedium2" align="center">
	  <font color="red">	 
	  <cfif check.recordcount eq "1">
	  <cf_tl id="There is #check.recordcount# ledger posting which is not in balance. Contact your administrator">	
	  <cfelse>
	  <cf_tl id="There are #check.recordcount# ledger postings that are not in balance. Contact your administrator">	 
	  </cfif>
	  </font>
	</tr>
</cfif>
