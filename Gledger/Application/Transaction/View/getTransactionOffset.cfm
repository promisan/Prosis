
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
	
<!--- we obtain the transaction that serve (parent) this parent transaction and that have the same account so it is normally meant as offset --->

<cfquery name="Associated" 
    datasource="AppsLedger" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	SELECT    TL.Journal as LineJournal, 
			  (SELECT Description FROM Journal WHERE Journal = TL.Journal) as LineJournalName,
	          TL.JournalSerialNo      as LineJournalSerialNo, 
			  TL.JournalTransactionNo as LineJournalTransactionNo, 
			  TL.TransactionLineId,
			  TL.ParentLineId,
			  TL.TransactionDate,
			  TL.Reference,
			  TL.TransactionType,
			  TL.TransactionCurrency,
			  TL.Currency, 
			  TL.GLaccount,
			  TL.AmountDebit,
			  TL.AmountCredit,
			  TL.TransactionAmount, 
			  TL.ExchangeRate, 
			  TL.ParentJournal,
			  TL.ParentJournalSerialNo,
			  <!--- correct offset again parent transaction as you can pay in different modes --->
              TL.AmountDebit  * TL.ExchangeRate AS Debit, 
			  TL.AmountCredit * TL.ExchangeRate AS Credit
			  
    FROM      TransactionLine AS TL 
		   	  <!--- Parent of this offset --->
	          INNER JOIN TransactionHeader AS TH ON TL.ParentJournal = TH.Journal AND TL.ParentJournalSerialNo = TH.JournalSerialNo 
			  <!--- header of the line ONLY valid transaction --->
			  INNER JOIN TransactionHeader AS LH ON TL.Journal         = LH.Journal 
			                                    AND TL.JournalSerialNo = LH.JournalSerialNo 
												AND LH.RecordStatus <> '9' 
												AND LH.ActionStatus IN ('0', '1')
	WHERE 	  TL.ParentJournal         = '#get.Journal#' 
    AND       TL.ParentJournalSerialNo = '#get.JournalSerialNo#' 
	<!--- this is to find the offset from the parent --->
    AND  	  TL.GLAccount             = '#SelectLines.GLAccount#'					  																					 	
	AND      	TH.RecordStatus <> '9' AND TH.ActionStatus IN ('0', '1')													 
	
	ORDER BY   TL.Created DESC
					
</cfquery>

<cfoutput>

<table width="90%" border="0" align="center" class="navigation_table">

	<tr class="labelmedium2 line">
	    <td style="width:80%"><cf_tl id="Transaction"></td>
		   <td style="min-width:90px"><cf_tl id="Date"></td>
		   <td style="min-width:30px" colspan="2"><cf_tl id="Transaction amount"></td>		  
		   <td style="min-width:100px" align="right"><cf_tl id="Exchange rate"></td>
		   <td style="min-width:100px" align="right">
		   <cfif SelectLines.Total lt 0><cf_tl id="Credit"><cfelse><cf_tl id="Debit"></cfif>		   
		   </td>
	</tr>	
	
	<tr class="labelmedium2 line">
	    <td style="width:80%;font-size:18px">#Get.JournalTransactionNo#</td>
		<td style="font-size:15px">#dateformat(get.TransactionDate,client.dateformatshow)#</td>
		<td style="font-size:15px">#Get.Currency#</td>
		<td></td>
		<td></td>
		<td style="min-width:100px;font-size:20px" align="right">#numberformat(SelectLines.Total,',.__')#</td>
	</tr>	
	
	<cfloop query="Associated">
	
	<cfif selectLines.GLAccount eq GLAccount>
		
	<tr class="labelmedium navigation_row line" style="height:23px">
	    <td style="width:80%;font-size:14px;padding-left:5px"><a href="javascript:ShowTransaction('#linejournal#','#linejournalserialNo#')">#LineJournalName# #currency#</td>
		<td style="min-width:90px;;font-size:14px">#dateformat(TransactionDate,client.dateformatshow)#</td>
		   <td style="min-width:40px;;font-size:14px">#TransactionCurrency#</td>
		   <td align="right" style="min-width:80px;;font-size:14px"><cfif currency neq get.currency>#numberformat(TransactionAmount,',.__')#</cfif></td>
		   <td align="right" style="min-width:80px;;font-size:14px">
		   
		   
		   <cfif currency neq get.currency>
		  
			   <cfif credit gt 0>
			   #numberformat(Credit/TransactionAmount,',.____')#
			   <cfelse>#numberformat(Debit/TransactionAmount,',.____')#
			   </cfif>
		   
		   </cfif>
		   		   
		   </td>
		   <td style="min-width:120px;font-size:14px;padding-right:4px" align="right"><cfif credit gt 0>#numberformat(Credit,',.__')#<cfelse>#numberformat(Debit,',.__')#</cfif></td>
	</tr>	
	
	<!--- From the offset line we now get the complementing transaction line (debit/credit) and then its parent that would revail the cause of the transaction --->
	
	<cfif ParentLineId neq "">
		    
		<cfquery name="Cause" 
	    datasource="AppsLedger" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
			SELECT      TL.ParentJournal, TL.ParentJournalSerialNo, TH.JournalTransactionNo, TransactionCurrency, TransactionAmount, TL.TransactionDate
			FROM        TransactionLine AS TL INNER JOIN
		                TransactionHeader AS TH ON TL.ParentJournal = TH.Journal AND TL.ParentJournalSerialNo = TH.JournalSerialNo
			WHERE       TL.Journal         = '#LineJournal#'
			AND         TL.JournalSerialNo = '#LineJournalSerialNo#'
			
			<!--- this is to fine the complementing transaction correctly in case there are many transaction like in payments --->
						
			AND         TL.GLAccount <> '#GLAccount#'					
			<cfif AmountDebit gt 0>
			AND         TL.AmountCredit = '#amountDebit#'
			<cfelse>
			AND         TL.AmountDebit  = '#amountCredit#' 
			</cfif>			
							
		</cfquery>
		
		<!--- a pragmatic filter as we can completely align debit and credit, 
		we better need a field to that groups debit/credit them together under a combined Id --->
		
		<cfif Cause.recordcount gt "1">
		
			<cfquery name="Cause" dbtype="query">
			SELECT      *
			FROM        Cause
			WHERE       ParentJournal         = '#ParentJournal#'
			AND         ParentJournalSerialNo = '#ParentJournalSerialNo#'
			
			</cfquery>		
		
		</cfif>
					
		<cfloop query="Cause">
		
		<cfif parentjournal neq get.journal and parentjournalserialno neq get.journalserialno>
		
		<tr class="labelmedium navigation_row line" style="height:20px;background-color:f1f1f1">
	    <td style="width:80%;font-size:13px;padding-left:15px"><a href="javascript:ShowTransaction('#parentjournal#','#parentjournalserialNo#')">#JournalTransactionNo#</a>&nbsp;<span style="font-size:12px">[#ParentJournal# #ParentJournalSerialNo#]</span></td>		
		<td style="font-size:15px"></td>
		   <td style="min-width:80px;;font-size:13px">#Transactioncurrency#</td>
		   <td style="min-width:80px;;font-size:13px" align="right">#numberformat(TransactionAmount,',.__')#</td>
		   <td align="right" style="min-width:80px;;font-size:13px"></td>
		   <td style="min-width:120px;font-size:13px" align="right"></td>
	    </tr>	
		
		</cfif>
		
		</cfloop>
	
	
	</cfif>
		
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
	   <td colspan="5" style="min-width:120px;font-size:20px" align="right"><cfif abs(get.AmountOutstanding) gte "0.05">#NumberFormat(get.AmountOutstanding,',.__')#<cfelse><span style="color:green"><cf_tl id="Nihil"><font size="1">#NumberFormat(get.AmountOutstanding,',.__')#</font></span></cfif></td>
	</tr>	

</table>

</cfoutput>

<cfset ajaxonload("doHighlight")>