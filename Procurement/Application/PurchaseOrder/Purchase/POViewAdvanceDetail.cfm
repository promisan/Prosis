
<cfoutput>

<table width="100%" align="center">

<cfquery name="Lines" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">			
		SELECT   H.Journal,
		         H.JournalSerialNo,
				 H.JournalTransactionNo, 
		         H.Description, 
				 H.Reference, 
				 H.TransactionId,
				 H.AccountPeriod,
				 H.TransactionDate, 
				 H.TransactionPeriod,
				 TL.Currency, 
				 TL.AmountDebit, 
				 TL.AmountCredit, 
				 TL.GLAccount,
				 H.ReferenceName, 
				 H.ReferenceNo,
				 H.ActionStatus,
				 H.OfficerFirstName,
				 H.OfficerLastName
		FROM     TransactionHeader H INNER JOIN
		         TransactionLine TL ON H.Journal = TL.Journal AND H.JournalSerialNo = TL.JournalSerialNo
		WHERE    H.Reference            = 'Advance' 
		AND      H.TransactionSource    = 'PurchaseSeries' 
		AND      H.TransactionSourceNo  = '#URL.ID1#' 
		AND      TL.TransactionSerialNo != '0'
		ORDER BY H.TransactionDate
</cfquery>
		
<cfquery name="Invoice" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT    * 
        FROM      Invoice
		WHERE     InvoiceId IN (SELECT InvoiceId 
		                        FROM   InvoicePurchase 
								WHERE  PurchaseNO = '#URL.ID1#')
		ORDER BY  DocumentDate
</cfquery>  		
				
<cfif Lines.recordcount eq "0" and Invoice.recordcount eq "0">		
	
	<tr class="line  labelmedium" style="background: white;">
	 	<td></td><td colspan="9" style="height:40px;font-size:17px" align="center">		
		 <a href="javascript:requestadvance('#url.id1#')"><cf_tl id="Press Here to request an Advance Payment"></a>
		</td>
	</tr>

</cfif>
			
<cfif Lines.recordcount eq "0" and Invoice.recordcount gt "0">		

	<tr>
	 	<td></td><td colspan="9" height="25" align="center" class="labelmedium">
		 <cf_tl id="No advances were issued">
		</td>
	</tr>

</cfif>
	
<tr><td colspan="10">

	<table width="100%" class="formpadding navigation_table">
		
		<cfif Lines.recordcount gte "1">
		 
		    <TR class="labelmedium2 line">
			   <td height="18" width="20"></td>
			   <td width="2%">&nbsp;</td>	
			   <td><cf_tl id="Reference"></td>
			   <td style="width:100px"><cf_tl id="Statement"></td>   
			   <td width="30%"><cf_tl id="Description"></td>				   
			   <td style="width:120px"><cf_tl id="Transaction Date"></td>
			   <td style="width:100px"><cf_tl id="Period"></td>
			   <td width="80"><cf_tl id="Status"></td>
			   <td width="120"><cf_tl id="Officer"></td>
			   <td width="80" align="center"><cf_tl id="Currency"></td>
		       <td width="100" align="right"><cf_tl id="Advance"></td>
			   <td width="100" align="right"><cf_tl id="Offset"></td>
			   <td width="20"></td>
			 </TR> 						 	
		 							
			 <cfif Lines.recordcount eq "0">
		
				 <tr><td colspan="11" align="center" class="labelmedium2"><font color="gray"><cf_tl id="No advances recorded"></td></tr>  
		 
			 <cfelse>
				
					<cfloop query="Lines">
													
						<tr class="line labelmedium2 navigation_row">
									
							<td align="center">#CurrentRow#</td>
														
						    <td align="center" style="padding-top:2px">						
								<cf_img icon="open" onClick="javascript:ShowTransaction('#Journal#','#JournalSerialNo#')">							
							</td>
							
							<td>#ReferenceNo#</td>	
							<td>#AccountPeriod#</td>	
							<td>#Description#</td>						
							<td>#DateFormat(TransactionDate,CLIENT.DateFormatShow)#</td>
							<td>#TransactionPeriod#</td>
							<td><cfif ActionStatus eq "1"><cf_tl id="Cleared">
								<cfelseif ActionStatus eq "0"><cf_tl id="Pending">
								</cfif>
							</td>
							<td>#OfficerLastName#</td>
							<td align="center">#Currency#</td>
							<td align="right">#NumberFormat(AmountDebit,",.__")#</td>
							
							<cfquery name="Offset" 
							datasource="AppsLedger" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								SELECT  SUM(AmountCredit*ExchangeRate) as Total 
								FROM    TransactionLine
								WHERE   ReferenceNo = '#URL.ID1#'	
								AND     ParentJournal         is not NULL
								AND     ParentJournalSerialNo is not NULL
								AND     GLAccount = '#GLAccount#'		
							</cfquery>						
													
							<td align="right">
							
							<cfif Offset.Total eq "">
							    <cfset offsetamt = 0>
							<cfelse>
								<cfset offsetamt = Offset.total>						
							</cfif> 
													
							<cfif abs(OffsetAmt-AmountDebit) gte 0.05>
								<font color="FF0000">#NumberFormat(Offset.total,",.__")#</font>
							<cfelse>
								#NumberFormat(Offset.total,",.__")#
								<img src="#SESSION.root#/Images/check.gif" align="absmiddle" alt="" border="0">
							</cfif>
																			
							</td>	
							
							<td align="center">
							
							<!--- if advance is not processed, allow to remove it !! --->
							
							<cfquery name="Check" 
								datasource="AppsLedger" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">			
								SELECT  *
								FROM    TransactionLine
								WHERE   ParentJournal = '#Journal#' 
								AND     ParentJournalSerialNo = '#JournalSerialNo#'
							</cfquery>
							
							<cfif Check.recordcount eq "0">
							
								<cf_img icon="delete" tooltip="Remove advance request"
									 onclick="ptoken.navigate('#SESSION.root#/Procurement/Application/PurchaseOrder/Purchase/POViewAdvance.cfm?del=#transactionid#&id1=#url.id1#','advances')">
									 
							</cfif>
							
							</td>		
			           	</tr>			
								
				  </cfloop>
				
			</cfif>		
		
		</cfif>
		
		</table>

	</td></tr>
		
</table>

</cfoutput>

<cfset ajaxonload("doHighlight")>