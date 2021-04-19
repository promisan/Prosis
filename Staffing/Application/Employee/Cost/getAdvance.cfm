
<cfif url.class eq "Deduction">
	
	<cfquery name="Advance" 
		datasource="AppsLedger" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
		SELECT *
		FROM (
	
		SELECT        Journal, 
		              JournalSerialNo, 
					  TransactionId,
					  TransactionDate, 
					  Description, 
					  Currency, 
					  Amount, 
					  AmountOutstanding,
		              (SELECT   ISNULL(SUM(Amount), 0) AS Expr1
		               FROM     Payroll.dbo.PersonMiscellaneous
		               WHERE    Source = 'Ledger' 
					   AND      SourceId = H.TransactionId) AS AmountRecovery,
		              (SELECT   ISNULL(SUM(Amount), 0) AS Expr1
		               FROM     Payroll.dbo.PersonMiscellaneous
		               WHERE    Source = 'Ledger' 
					   AND      SourceId = H.TransactionId 
					   AND      H.ActionStatus = '5') AS AmountRecovered, 
					   OfficerUserId, 
					   OfficerLastName, 
					   OfficerFirstName
		FROM           TransactionHeader AS H
		WHERE          ReferencePersonNo = '#url.personno#' 
		AND            ReferenceNo       = 'Payroll'
		AND			   ActionStatus = '1'
		AND            RecordStatus = '1'
			
		) as D
		
		<!--- still pending recovery --->
		
		WHERE Amount > AmountRecovered
		           
	</cfquery>
	
	<table style="width:100%;background-color:f5f5f5" class="navigation_table">
		
		<tr class="labelmedium2 line">
		   <td style="width:35px"></td>
		   <td style="padding-left:4px;border:1px solid silver;padding-right:4px"><cf_tl id="Ledger"></td>
		   <td style="padding-left:4px;border:1px solid silver;padding-right:4px"><cf_tl id="Date"></td>
		   <td style="padding-left:4px;border:1px solid silver;padding-right:4px"><cf_tl id="Description"></td>	   
		   <td style="min-width:100px;border:1px solid silver;padding-right:4px" align="right"><cf_tl id="Advance"></td>
		   <td style="min-width:100px;border:1px solid silver;padding-right:4px" align="right"><cf_tl id="Payable"></td>
		   <td style="min-width:100px;border:1px solid silver;padding-right:4px" align="right"><cf_tl id="Planned"></td>
		   <td style="min-width:100px;border:1px solid silver;padding-right:4px" align="right" style="padding-right:4px"><cf_tl id="Recovered"></td>
		</tr> 
		<tr class="labelmedium2 line navigation_row">
		     <td align="center" style="padding-bottom:2px"><input class="radiol" type="radio" name="ledger" checked value="" 
			  onclick="ptoken.navigate('getCurrency.cfm?id=#url.personno#','currencybox')"></td>
		     <td colspan="8"><cf_tl id="No applicable"></td>		 
		</tr>  
		
		<cfoutput query="Advance">  
		  <tr class="labelmedium2 line navigation_row">
		     <td align="center" style="padding-bottom:2px"><input class="radiol"  type="radio" name="ledger" value="#TransactionId#" 
			    onclick="ptoken.navigate('getCurrency.cfm?currency=#currency#&id=#url.personno#','currencybox')"></td>
		     <td style="padding-left:4px;border:1px solid silver;padding-right:4px"><a href="javascript:ShowTransaction('#journal#','#journalserialNo#','','tab','')">#Journal#-#journalSerialNo#</a></td>
			 <td style="padding-left:4px;border:1px solid silver;padding-right:4px">#dateformat(TransactionDate,client.dateformatshow)#</td>
			 <td style="padding-left:4px;border:1px solid silver;padding-right:4px">#description# #Currency#</td>		 
			 <td style="border:1px solid silver;padding-right:4px" align="right">#numberformat(Amount,",.__")#</td>
			 <td style="border:1px solid silver;padding-right:4px" align="right"><cfif AmountOutstanding gt "0"><font color="FF0000"></cfif>#numberformat(AmountOutstanding,",.__")#</td>
			 <td style="border:1px solid silver;padding-right:4px" align="right">#numberformat(AmountRecovery,",.__")#</td>
			 <td style="border:1px solid silver;padding-right:4px" align="right" style="padding-right:4px">#numberformat(AmountRecovered,",.__")#</td>
		   </tr>
		</cfoutput> 
			
	</table>

<cfelse>

</cfif>

<cfoutput>
<script>
    ptoken.navigate('getCurrency.cfm?id=#url.personno#','currencybox')
</script>
</cfoutput>

<cfset ajaxOnLoad("doHighlight")>