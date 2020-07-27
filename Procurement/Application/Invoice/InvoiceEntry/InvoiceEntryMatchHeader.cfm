
<!--- select all PO's for this vendors with the same type --->

<cfparam name="url.DrillId" default="">
<cfparam name="url.PurchaseNo" default="#url.drillid#">
<cfparam name="PO.PurchaseNo" default="#url.purchaseNo#">
<cfparam name="mode" default="Match"> <!--- called from invoice matching screen --->

<cfif mode eq "Match">

	<cfquery name="IssuedPO" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   P.Mission, 
		         P.PurchaseNo, 
		         P.UserDefined1,
		         P.UserDefined2,
		         P.UserDefined3,
				 P.PurchaseSerialNo,
				 P.OrderDate, 
				 R.ReceiptEntry,
				 R.InvoiceWorkflow,
				 PL.Currency, 
				 P.DeliveryDate, 
				 P.OrderType,
				 P.ActionStatus,	
				 P.ObligationStatus,			
				 SUM(PL.OrderAmount) as OrderAmount
				 
		FROM     Purchase P, 
		         PurchaseLine PL,
				 Ref_OrderType R  
		WHERE    P.Mission       = '#URL.Mission#' 
		   AND   P.Period        = '#URL.Period#' <!--- only issued for this period --->		
		   	    							   		     
		  
		  		   
		   AND 
			    (
		   		       (
					  		(P.OrgUnitVendor = '#URL.OrgUnit#' AND P.OrgUnitVendor <> '0') 
					        OR (P.PersonNo = '#URL.PersonNo#' AND P.PersonNo <> '')
						    OR P.InvoiceAssociate = 1
						)	
						  				   
					  AND P.OrderType   = '#PO.OrderType#'  <!--- import to keep the same ordertype  for posting !!!! --->
					  AND P.OrderClass  = '#PO.OrderClass#' <!--- import to keep the same orderclass for posting !!!! --->					  
							
				)
					
		
		   
		   AND   P.Currency      = '#PO.Currency#'   <!--- import to keep the same currency   for posting !!!! --->
		   AND   P.PurchaseNo    =  PL.PurchaseNo
		   AND   R.Code          =  P.OrderType 
		   
		   <!--- status = 4 is disbused we only show purchases orders in process --->
    	   AND   (P.ActionStatus IN ('3') OR P.Purchaseno = '#PO.Purchaseno#') 		
				
		   <!--- Pending : excluded invoices that are fully invoiced --->
		 
		GROUP BY P.Mission, 
		         P.PurchaseNo, 
		         P.UserDefined1,
		         P.UserDefined2,
		         P.UserDefined3,
				 P.PurchaseSerialNo,
				 P.OrderType, 
				 P.OrderDate, 
				 P.DeliveryDate, 
				 P.ActionStatus, 
				 PL.Currency, 
				 R.ReceiptEntry,
				 R.InvoiceWorkflow,
				 P.ObligationStatus    
		ORDER BY P.PurchaseNo 
	</cfquery>

<cfelse>
	
	<cfquery name="IssuedPO" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   P.Mission, 
		         P.PurchaseNo, 
				 P.PurchaseSerialNo,
				 P.OrderDate, 
				 R.ReceiptEntry,
				 R.InvoiceWorkflow,
				 PL.Currency, 
				 P.DeliveryDate, 
				 P.OrderType,
				 P.ActionStatus,	
				 P.ObligationStatus,			 
				 SUM(PL.OrderAmount) as OrderAmount
		FROM     Purchase P, 
		         PurchaseLine PL,
				 Ref_OrderType R  
		WHERE    P.PurchaseNo    =  PL.PurchaseNo
		   AND   R.Code          =  P.OrderType 
		   <!--- remove 10/6/2013
		   AND   P.ActionStatus >= '3' <!--- only issued for this period --->
		   --->
		   AND   P.Purchaseno    = '#PO.Purchaseno#' 	
		     
		GROUP BY P.Mission, 
		         P.PurchaseNo, 
				 P.PurchaseSerialNo,
				 P.OrderType, 
				 P.OrderDate, 
				 P.DeliveryDate, 
				 P.ActionStatus, 
				 PL.Currency, 
				 R.ReceiptEntry,
				 R.InvoiceWorkflow,   
				 P.ObligationStatus 
		ORDER BY P.PurchaseNo 
	</cfquery>	

</cfif>

<table width="100%" border="0" align="center">

	<cfif mode eq "Match">		
		
	<tr>
		<td colspan="12" height="30" style="padding-right:15px" align="right" class="labelmedium" id="invoicetotalselect">	
			<cf_tl id="Associated amount"> : 0.00
		</td>
	</tr>
		
	<cfelseif mode eq "list">	
	<tr><td colspan="11" class="line"></td></tr>
	</cfif>
				
	<tr class="labelmedium line" bgcolor="ffffff" style="height:20px">
	   <td width="10"></td>
	   <cfif mode eq "match">
		   <td height="20"><cf_tl id="PurchaseNo"></td>
		   <td height="20"><cf_tl id="UserDefined1"></td>
		   <td><cf_tl id="Order date"></td>
		   <td><cf_tl id="Delivery date"></td>
	   <cfelse>
	    <td colspan="2" width="160"></td>		
		<td><cf_tl id="Delivery"></td>   
	   </cfif>
	   <td class="labelit"><cf_tl id="Curr"></td>
	   <td align="right" width="90"><cf_tl id="Issued for"></td>
	   
	   <cf_tl id="Receipts for Purchase Order but not matched to an invoice yet" var="1">
	   <td align="right" width="90"><a href="##" title="<cfoutput>#lt_text#</cfoutput>"><cf_tl id="Receipts"></a></td>
	   
	   <cf_tl id="Invoice in Routing" var="1">
	   <td align="right" width="90"><a href="##" title="<cfoutput>#lt_text#</cfoutput>"><cf_tl id="In Process"></a></td>
	   
	   <cf_tl id="Invoice Posted in GL" var="1">
	   <td align="right" width="90"><a href="##" title="<cfoutput>#lt_text#</cfoutput>"><cf_tl id="GL Posted"></a></td>	  
	   <td align="right" width="123"><cf_tl id="Available Balance"></td>	   
	</tr>
			
	<!--- allow association ONLY for PO that are not fully matched/paid --->
			
	<cfoutput query="IssuedPO" group="PurchaseNo">
			
				<cfset go = "0">
				
				<!--- ------------------------------------------------------------------------------ --->
				<!--- this condition has to be changed to look at the receiptEntry parameter instead --->
				<!--- ------------------------------------------------------------------------------ --->
															
				<cfif ReceiptEntry neq "9">
								
					<!--- retrieve total amount already received 
					on this purchase order --->
					
					<cfset rct = 0>
					
					<!---
					<cfif parameter.InvoicePriorReceipt eq "0">
					--->
					
						<!--- ATTENTION if Purchase is not issued in base currency, the dcoument amount will need to be
						corrected for the base currency --->
				
							<cfquery name="Receipt" 
							datasource="AppsPurchase" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								SELECT  PL.PurchaseNo, 
								        PR.Currency,
								        SUM(ReceiptAmount) AS ReceiptAmount
								FROM    PurchaseLine PL, PurchaseLineReceipt PR
								WHERE   PurchaseNo       = '#PurchaseNo#'
								AND     PL.RequisitionNo = PR.RequisitionNo
								AND     PR.ActionStatus != '9'
								<!---
								AND     PR.ActionStatus = '1'  <!--- mean receipt cleared not matched --->   
								--->
								GROUP BY PurchaseNo, PR.Currency
							</cfquery>
							
							<!--- correction for the receipt currency --->
											
							<cfloop query="Receipt">
						
								<cf_exchangeRate 
							        CurrencyFrom = "#Currency#" 
							        CurrencyTo   = "#IssuedPO.currency#">
																				
								<cfset rct = rct+(ReceiptAmount*exc)>
																	
							</cfloop>				
					
					  <!---					
					  </cfif>
					  --->
					
				<cfelse>
				
					<cfset rct = 0>		
											
				</cfif>	
				
				<cf_verifyOperational module = "Accounting" Warning   = "No">
				
								
				<cfif operational eq "1">
				
					<!--- no amounts are recorded as received in this scenario, and you can only associate an invoice to 1 (one) PO
					so instead the recorded GL invoice amounts are shown to the user
					retrieve total amount already received 
					on this purchase order --->
					
					<!--- take transaction currency which is the same as PO currency here --->
					
					<cfquery name="Posted" 
					datasource="AppsPurchase" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					
						SELECT     I.InvoiceId,
						           GLL.TransactionDate, 
						           GLL.currency, 
								   <!--- adjusted 20/4/2016 as the invoice may be split over various purchase orders  so we apply the ratio --->
								   SUM((GLL.AmountCredit-GLL.AmountDebit)*(P.DocumentAmountMatched/I.DocumentAmount)) AS PaidAmount								   
						FROM       InvoicePurchase P INNER JOIN
		                   		   Invoice I ON P.InvoiceId = I.InvoiceId INNER JOIN
			                       Accounting.dbo.TransactionHeader GL ON I.InvoiceId = GL.ReferenceId INNER JOIN
		       		               Accounting.dbo.TransactionLine GLL ON GL.JournalSerialNo = GLL.JournalSerialNo AND GL.Journal = GLL.Journal
						 WHERE     PurchaseNo = '#PurchaseNo#'  
						 AND       I.ActionStatus != '9'
						 AND       GLL.TransactionSerialNo = '0'
						 AND       GL.ActionStatus != '9'
						 AND       GL.RecordStatus != '9'
						 AND       (GLL.ParentJournal = '' or GLL.ParentJournal is NULL)
						 GROUP BY  I.InvoiceId,
						           GLL.TransactionDate,
						           GLL.Currency								   
					
					</cfquery>		
					
					<cfset pur = PurchaseNo>			
														
					
					<!--- ATTENTION if Invoice is not issued in same currency as PO, the docoument amount is
					corrected for the base currency of the PO to give a balance figure ysing current
					exchange rates --->
					
					<cfset exp = 0>
					<cfset pocurr = Currency>
					
					<cfloop query="Posted">
					
						<cfif PaidAmount gt "0">
							<cfset amt = PaidAmount>
						<cfelse>
						    <cfset amt = 0>
						</cfif>
						
						<!--- 27/12/2019 : a correction to apply the exchange rate as it was applied during matching 
						
						 amountmatched relates to the receipt currency
						 documentAmountMatched to the currency of the invoice = document
						
						--->
						
						<cfquery name="Exchange" 
						datasource="AppsPurchase" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">	
							SELECT       SUM(AmountMatched) / SUM(DocumentAmountMatched) AS Exchange
							FROM         InvoicePurchase
							WHERE        PurchaseNo = '#pur#'
							AND          Invoiceid = '#Invoiceid#' 
							AND          DocumentAmountMatched > 0  						
						 </cfquery>
						 
						 <cfif Exchange.recordcount eq "1">
						 
						 	<cfset exp = exp+(amt*Exchange.Exchange)>
						 
						 <cfelse>
												
							<cf_exchangeRate 
							        CurrencyFrom = "#Currency#" 
							        CurrencyTo   = "#IssuedPO.currency#"
									EffectiveDate = "#dateformat(TransactionDate,CLIENT.DateFormatShow)#">
									
							<cfif Exc eq "0" or Exc eq "">
								<cfset exc = 1>
							</cfif>								
																									
						    <cfset exp = exp+(amt/Exc)>
							
						  </cfif>	
					
					</cfloop>
					
				<cfelse>
				
					<!--- nothing posted in this mode --->
				   <cfset exp = 0>
								
				</cfif>	
																							
				<cfquery name="Pending" 
					datasource="AppsPurchase" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT    DocumentCurrency,
						          SUM(DocumentAmountMatched) AS Amount <!--- invoice portion --->
						FROM      InvoicePurchase Pur INNER JOIN
		                   		  Invoice I ON Pur.InvoiceId = I.InvoiceId 
						WHERE     PurchaseNo = '#PurchaseNo#' 		
						<cfif operational eq "0">		
						<!--- invoices in procurement system only --->
						<cfelse>
						<!--- excluded posted invoices --->
						AND       I.InvoiceId NOT IN (SELECT ReferenceId 
						                              FROM   Accounting.dbo.TransactionHeader 
													  WHERE  ReferenceId is not NULL)
						</cfif>						
						AND       I.ActionStatus != '9' 
						GROUP BY  DocumentCurrency
				</cfquery>
					
				<!--- ATTENTION if Invoice is not issued in same currency as PO, the docoument amount is
					corrected for the base currency of the PO to give a balance figure ysing current
					exchange rates --->
								
				<cfset pen = "0">											
					
				<cfloop query="Pending">
					
					<cf_exchangeRate 
				        CurrencyFrom = "#DocumentCurrency#" 
				        CurrencyTo   = "#IssuedPO.currency#">
								
						<cfif Exc eq "0" or Exc eq "">
							<cfset exc = 1>
						</cfif>								
																								
						<cfset pen = pen+(Amount/Exc)>
																
				</cfloop>	
				
				<!--- update the status of the purchase --->
				
				<cfquery name="Update" 
					datasource="AppsPurchase">
					UPDATE Purchase
					SET    ActionStatus     = '3'
					WHERE  PurchaseNo       = '#PurchaseNo#'
					AND    ActionStatus     = '4'
					AND    ObligationStatus = '1'
				</cfquery>	
				
				<cfif operational eq "1">
				
					<cfquery name="Update" 
					datasource="AppsPurchase">
						UPDATE skPurchase
						SET    InvoiceAmount = '#exp#'
						WHERE  PurchaseNo = '#PurchaseNo#'					
					</cfquery>	
					
				<cfelse>
				
					<cfquery name="Update" 
					datasource="AppsPurchase">
						UPDATE skPurchase
						SET    InvoiceAmount = '#pen#'
						WHERE  PurchaseNo = '#PurchaseNo#'					
					</cfquery>					
				
				</cfif>
							
				<cfquery name="Update" 
					datasource="AppsPurchase">
					UPDATE   Purchase
					SET      ActionStatus = '4'
					
					FROM     skPurchase T,Purchase P
					WHERE    T.PurchaseNo = P.PurchaseNo
					AND      abs(T.OrderAmount - T.InvoiceAmount) < 0.05
					AND      P.PurchaseNo = '#PurchaseNo#'
				</cfquery>	
																					
				<cfset go = "1">
								
				<cfif go gt "0">
							
					<cfif OrderAmount gte Exp+Pen>
					   <cfset cl = "ffffff">
					 <cfelse>
					   <cfset cl = "f1f1f1">
					 </cfif>
					 
					<tr bgcolor="#cl#" class="labelmedium line" style="height:10px">
					   
					   <cfif mode eq "match">
					   	   
						   <td width="10" style="height:23px"></td>
						   <td>						  
						   <a href="javascript:ProcPOEdit('#PurchaseNo#','view')">
						   		<cf_getPurchaseNo purchaseNo="#PurchaseNo#" mode="only">
						   </a>						   
						   </td>
						   <td>#UserDefined1#</td>						   
						   <td>#DateFormat(OrderDate, CLIENT.DateFormatShow)#</td>
						  						   
					   <cfelse>
					   
						   <td colspan="3" style="border-right; border-right: 1px solid silver;">	
						  				   
						   &nbsp;&nbsp;<a href="javascript:ProcPOEdit('#PurchaseNo#','view')">#PurchaseNo#</a>
						   &nbsp;<font color="gray"><cf_tl id="Execution status"> : </b>
						   <cfif ObligationStatus eq "0"><font color="FF0000"><cf_tl id="Closed"></font>
						   <cfelseif ActionStatus eq "4"><font color="FF0000"><cf_tl id="Disbursed"></font>
						   <cfelse><font color="008000"><cf_tl id="Open"></cfif>
						   </td>		
						   				    
					   </cfif>
					   
					   <td               bgcolor="Ffffcf" style="padding-left:4px">#DateFormat(DeliveryDate, CLIENT.DateFormatShow)#</td>
					   <td width="50"    bgcolor="Ffffcf">#IssuedPO.currency#</td>
					   <td align="right" bgcolor="Ffffcf">#NumberFormat(OrderAmount,",.__")#</td>
					   <td align="right" bgcolor="Ffffcf"><cfif ReceiptEntry neq "9">#NumberFormat(Rct,",.__")#<cfelse>N/A</cfif></td>
					   <td align="right" bgcolor="Ffffcf">#NumberFormat(Pen,",.__")#</td>
					   <td align="right" bgcolor="Ffffcf">#NumberFormat(Exp,",.__")#</td>					   
					   <td align="right" bgcolor="Ffffcf">#NumberFormat(OrderAmount-Exp-Pen,",.__")#</td>
					   
					   <input type="hidden" name="selcurrency" id="selcurrency" value="#IssuedPO.currency#">
					  					   
					   <cfif OrderAmount gt Exp+Pen>
					   
					   	   <td style="width:20px;padding-left:5px;padding-right:6px">
						  				  		   						   
						   						   
						   <cfif mode eq "Match">
						   
						     <cfif IssuedPO.recordcount eq "1">
						  						   
							   	 <input type  = "checkbox" 
								    id        = "#purchaseNo#" 
									name      = "selectedpurchase" 
									value     = "#purchaseSerialNo#" 
									onClick   = "hl(this, this.checked)">
									  								  
									<cfif purchaseNo eq URL.PurchaseNo>
										<script>
											 document.getElementById('#purchaseno#').click()
										</script>  
									</cfif>		
																	 
							<cfelse>
							
								<table>
									<tr>
									<td style="padding-left:4px">
								
									 <input type  = "checkbox" 
									    id        = "#purchaseNo#" 
										name      = "selectedpurchase" 
										value     = "#purchaseSerialNo#" 
										onClick   = "hl(this, this.checked,'#purchaseSerialNo#')">
										
									</td>
																												
									<td style="padding-left:4px" id="#purchaseSerialNo#_amount" class="hide">
								
										 <cfset p = "0">
																												
										 <input type="Text" 
										      name     = "purchase_#purchaseSerialNo#" 
											  id       = "purchase_#purchaseSerialNo#"
											  style    = "text-align:right;border:0px;border-right:1px solid gray;;padding-top:2px;height:21px;font-size:12px" 									
											  onchange = "showassociatedtotal()"									 
											  class    = "regularxl enterastab" 
											  
											  visible  = "Yes" 
											  value    = "#numberformat(p,',.__')#" 										 
											  size     = "8" 
											  maxlength= "15">
											  
									</td>
									</tr>									
								</table>	  
													
							</cfif>	 
							 
						  <cfelseif mode eq "po">						  		  
						  	  					  						  
							  <cfquery name="PO" 
								datasource="AppsPurchase" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
									SELECT   *
									FROM     Purchase P 
									WHERE    P.Purchaseno    = '#Purchaseno#' 	  		  
									ORDER BY P.PurchaseNo 
							  </cfquery>
							  
							   <cfinvoke component = "Service.Access"  
								   method           = "createwfobject" 
								   entitycode       = "ProcInvoice"
								   mission          = "#PO.mission#"
								   returnvariable   = "accesscreate">   
							   
							   <cfif (accesscreate eq "EDIT" or accesscreate eq "ALL") and PO.ObligationStatus eq "1">	   
								  						   							   
								  		<cf_tl id="Record Incoming invoice" var="1">
										
										 <img src="#SESSION.root#/Images/insert.gif" 
											  alt="#lt_text#" 
											  name="img4" 
											  onMouseOver="document.img4.src='#SESSION.root#/Images/button.jpg'" 
											  onMouseOut="document.img4.src='#SESSION.root#/Images/insert.gif'"
											  height="13" 
											  width="13"
											  style="cursor: pointer;" 
											  border="0" 
											  align="absmiddle" 
											  onClick="invadd('#PO.orgunitvendor#','#PO.PurchaseNo#','#PO.PersonNo#')"> 
									  
								</cfif>  
							   
						  </cfif> 
						  
						  </td>
						  
					   <cfelse>
					   
						   <td align="right" bgcolor="Ffffcf" style="width:20px;padding-left:5px;padding-right:5px">
						       <img src="#SESSION.root#/Images/checked_green.gif" alt="" border="0">
							</td>
						
					   </cfif>
					 					  
				    </tr>
				
				</cfif>
		
	</cfoutput>
								
</table>