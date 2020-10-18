
<!--- get offsetting transactions --->

<cfinclude template="../../../../Tools/Process/Ledger/TransactionOutstanding.cfm">

	<cfquery name="get"
	   datasource="AppsLedger" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
			SELECT *
			FROM   TransactionHeader
			WHERE  Journal         = '#get.Journal#'	  
			AND    JournalserialNo = '#get.JournalSerialNo#'	  
	</cfquery>
	
<cfquery name="Associated" 
    datasource="AppsLedger" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	SELECT    TH.Journal, 
	          TH.JournalSerialNo, 
			  TH.JournalTransactionNo, 
			  TH.Description, 			  
			  TL.Journal as LineJournal, 
			  (SELECT Description FROM Journal WHERE Journal = TL.Journal) as LineJournalName,
	          TL.JournalSerialNo as LineJournalSerialNo, 
			  TL.JournalTransactionNo as LineJournalTransactionNo, 
			  TL.TransactionDate,
			  TL.Reference,
			  TL.TransactionType,
			  TL.Currency, 
			  TL.GLaccount,
			  TL.TransactionAmount, 
			  TL.ExchangeRate, 
              TL.AmountDebit  * TL.ExchangeRate AS Debit, 
			  TL.AmountCredit * TL.ExchangeRate AS Credit
			  
    FROM      TransactionLine AS TL INNER JOIN
              TransactionHeader AS TH ON TL.ParentJournal = TH.Journal AND TL.ParentJournalSerialNo = TH.JournalSerialNo INNER JOIN
                  (SELECT  TL.Journal, TL.JournalSerialNo, TL.GLAccount
                   FROM    TransactionLine AS TL INNER JOIN
                           TransactionHeader AS TH ON TL.Journal = TH.Journal AND TL.JournalSerialNo = TH.JournalSerialNo AND TH.RecordStatus <> '9' AND 
                           TH.ActionStatus IN ('0', '1')
                   WHERE   TL.ParentJournal = '#get.Journal#' 
				   AND     TL.ParentJournalSerialNo = '#get.JournalSerialNo#' 
				   AND     TL.GLAccount = '#SelectLines.GLAccount#') AS B ON TL.Journal = B.Journal
				                                                         AND TL.JournalSerialNo = B.JournalSerialNo 
																		 	
	WHERE     	TH.RecordStatus <> '9' AND TH.ActionStatus IN ('0', '1')													 
	
	ORDER BY TL.Journal, TL.JournalSerialNo, TL.TransactionSerialNo, TL.Created
</cfquery>

<cfoutput>

<table width="90%" align="center" class="navigation_table">

	<tr class="labelmedium line">
	    <td style="width:80%"><cf_tl id="Transaction"></td>
		   <td style="min-width:80px"><cf_tl id="Date"></td>
		   <td style="min-width:50px"><cf_tl id="Currency"></td>
		   <td style="min-width:80px"></td>
		   <td style="min-width:100px" align="right"><cf_tl id="Exchange rate"></td>
		   <td style="min-width:100px" align="right">
		   <cfif SelectLines.Total lt 0><cf_tl id="Credit"><cfelse><cf_tl id="Debit"></cfif>		   
		   </td>
	</tr>	
	
	<tr class="labelmedium line">
	    <td style="width:80%;font-size:18px">#Get.JournalTransactionNo#</td>
		<td style="width:80%;font-size:18px">#dateformat(get.TransactionDate,client.dateformatshow)#</td>
		<td style="min-width:80px;font-size:20px">#Get.Currency#</td>
		<td style="min-width:120px"></td>
		<td style="min-width:120px"></td>
		<td style="min-width:120px;font-size:20px" align="right">#numberformat(SelectLines.Total,',.__')#</td>
	</tr>	
	
	<cfloop query="Associated">
	
	<cfif selectLines.GLAccount eq GLAccount>
		
	<tr class="labelmedium navigation_row line">
	    <td style="width:80%;font-size:15px;padding-left:5px"><a href="javascript:ShowTransaction('#linejournal#','#linejournalserialNo#')">#LineJournalName#</td>
		<td style="width:80%;font-size:15px">#dateformat(TransactionDate,client.dateformatshow)#</td>
		   <td style="min-width:80px;;font-size:13px">#currency#</td>
		   <td style="min-width:80px;;font-size:13px"><cfif currency neq get.currency>#numberformat(TransactionAmount,',.____')#</cfif></td>
		   <td align="right" style="min-width:80px;;font-size:15px">#numberformat(ExchangeRate,',.____')#</td>
		   <td style="min-width:120px;font-size:15px" align="right"><cfif credit gt 0>#numberformat(Credit,',.__')#<cfelse>#numberformat(Debit,',.__')#</cfif></td>
	</tr>	
	
	<cfelse>
	
	<tr class="labelmedium navigation_row line">
	    <td style="width:80%;font-size:15px;padding-left:5px" colspan="3"><a href="javascript:ShowTransaction('#journal#','#journalserialNo#')">#JournalTransactionNo# #Description#</a></td>		
	</tr>	
	
	</cfif>
	
	</cfloop>
	
	<cfquery name="get"
	   datasource="AppsLedger" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
			SELECT *
			FROM   TransactionHeader
			WHERE  Journal         = '#get.Journal#'	  
			AND    JournalserialNo = '#get.JournalSerialNo#'	  
	</cfquery>
		
	<tr class="labelmedium line">
	    <td style="width:80%;font-size:18px"><cf_tl id="Balance"></td>		
		   <td colspan="4"></td>
		   <td style="min-width:120px;font-size:20px" align="right">#NumberFormat(get.AmountOutstanding,',.__')#</td>
	</tr>	

</table>

</cfoutput>

<cfset ajaxonload("doHighlight")>