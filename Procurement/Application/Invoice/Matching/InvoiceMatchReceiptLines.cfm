
 <!--- show receipt mapping screen --->

<tr><td colspan="7" style="padding-top:5px;padding-left:13px">

	 
<table width="100%" align="center">

	<tr><td width="100%">
	
		<table width="100%" border="0" align="center">
		
		<cfif Parameter1.InvoiceMatchPriceActual eq "1">
			<cfset col = "14">
		<cfelse>
			<cfset col = "11">
		</cfif>
						 
		<tr class="line">
		   
			<td colspan="9" style="FONT-SIZE:21px;;height:39;padding-left:4px" class="labelmedium">																			
			
			<cfif invoice.actionStatus eq "0">
				<font color="black"><cf_tl id="Match Payable to cleared receipts">
			<cfelse>
				<font color="black"><cf_tl id="Matched receipts">
			</cfif>
			</td>
			<cfif Parameter1.InvoiceMatchPriceActual neq "0">
			
				<td class="labelmedium" colspan="4" align="right">
				<cfif invoice.actionStatus eq "0">
				<a href="javascript:$('.myselect').prop( 'checked', true );total()">
					<cf_tl id="Select all lines">
				</a>	
				</cfif>
				</td>
				
			<cfelse>
			
				<td class="labelmedium" colspan="2" align="right">
				<cfif invoice.actionStatus eq "0">
				<a href="javascript:$('.myselect').prop( 'checked', true );total()">
					<cf_tl id="Select all lines">
				</a>	
				</cfif>
				</td>
			
			</cfif>
						
		</tr>
		
		<tr bgcolor="E6E6E6" class="labelmedium" class="line">
				
			   <td height="21" width="10"></td>
			   <td><!--- Purchase ---></td>
			   <td colspan="2" style="border-left:1px solid silver;padding-left:4px"><cf_tl id="Delivery"></td>
			   <td width="30%" colspan="2" style="padding-left:4px;border-left:1px solid silver;border-bottom:1px dotted silver"><cf_tl id="Product"></td>						  
			   <td style="padding-left:4px;border-left:1px solid silver"><cf_tl id="Qty"></td>
			   <td align="center" style="padding-left:4px;border-left:1px solid silver"><cf_tl id="Curr">.</td>
			   <td colspan="2" align="left" style="padding-left:4px;border-left:1px solid silver;padding-right:2px;border-bottom:1px dotted silver"><cf_tl id="Receipt"></td>
			   <cfif Parameter1.InvoiceMatchPriceActual neq "0">
			   <td colspan="3" align="left" style="padding-left:4px;border-left:1px solid silver;padding-right:2px;border-bottom:1px dotted silver"><cf_tl id="On Invoice"></td>						   						  
			   </cfif>
			   <td width="1%" style="border:1px solid silver"></td>
				  
		</tr>	
			
		<tr bgcolor="ffffaf" class="labelmedium">
		
			   <td style="width:2%"></td>
			   <td style="width:2%"><!--- No ---></td>
			   <td style="width:20%;padding-left:4px;border:1px solid silver"><cf_tl id="Date"> / <cf_tl id="Order"></td>
			   <td style="width:8%;padding-left:4px;border:1px solid silver"><cf_tl id="Recipient"></td>
			   <td style="padding-left:4px;border:1px solid silver"><cf_tl id="Name"></td>
			   <td style="width:50px;padding-left:4px;border:1px solid silver"><cf_tl id="Item"></td>
			   <td style="width:50px;padding-left:4px;border:1px solid silver"></td>
			   <td align="center" style="width:50px;border:1px solid silver"></td>
			   <td align="right" style="width:100px;border:1px solid silver;padding-right:2px;"><cf_tl id="Price"></td>
			   <td align="right" style="width:90px;border:1px solid silver;padding-right:2px"><cf_tl id="Amount"></td>
			   <cfif Parameter1.InvoiceMatchPriceActual neq "0">
			   <td align="right" style="width:90px;border:1px solid silver;padding-right:2px"><cf_tl id="Price"></td>
			   <td align="right" style="width:90px;border:1px solid silver;padding-right:2px"><cf_tl id="Tax"></td>
			   <td align="right" style="width:90px;border:1px solid silver;padding-right:2px"><cf_tl id="Amount"></td>
			   </cfif>
			   <td width="2%" style="border:1px solid silver"></td>
				  
		</tr>
		
		<cfif Invoice.ActionStatus eq "1">
				
			<cfquery name="Lines" 
				datasource="AppsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT   DISTINCT PR.*, PL.PurchaseNo, R.PackingSlipNo
			    FROM     InvoicePurchase IP, 
				         PurchaseLine PL, 
						 PurchaseLineReceipt PR,
						 Receipt R 
				WHERE    PL.RequisitionNo = PR.RequisitionNo 
				AND      IP.PurchaseNo    = PL.PurchaseNo 
				AND      PR.ActionStatus IN ('1','2')
				AND      R.ReceiptNo = PR.ReceiptNo
				AND      PR.InvoiceIdMatched  = '#URL.ID#' 
				ORDER BY PL.PurchaseNo 
								
			</cfquery>
		
		<cfelse>		
		
			<!--- update the invoice prices for data entry --->
			<cftry>
				<cfquery name="ClearZero" 
					datasource="AppsPurchase" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					DELETE FROM PurchaseLineReceipt						
			    	WHERE  RequisitionNo IN (SELECT RequisitionNo 
				                         	 FROM   PurchaseLine 
										 	 WHERE  PurchaseNo IN (#quotedValueList(Purchase.PurchaseNo)#))
					AND    ReceiptQuantity = '0'
				</cfquery>
			<cfcatch>
				
			</cfcatch>	
			</cftry>
						
			<cfquery name="Set" 
				datasource="AppsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				UPDATE PurchaseLineReceipt
				SET    InvoicePrice      = ReceiptAmount/ReceiptQuantity,
				       InvoiceAmountCost = ReceiptAmountCost,
					   InvoiceAmountTax  = ReceiptAmountTax
			    WHERE  RequisitionNo IN (SELECT RequisitionNo 
				                         FROM   PurchaseLine 
										 WHERE  PurchaseNo IN (#quotedValueList(Purchase.PurchaseNo)#))
				AND    InvoicePrice is NULL 
				AND    ReceiptQuantity = '0'
				AND    ActionStatus != '9'
			</cfquery>
							
			<cfquery name="Lines" 
				datasource="AppsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT  DISTINCT PR.*, PL.PurchaseNo, R.PackingSlipNo 
			    FROM    InvoicePurchase IP, 
				        PurchaseLine PL, 
						PurchaseLineReceipt PR, 
						Receipt R 
				WHERE   PL.RequisitionNo = PR.RequisitionNo 
				AND     IP.PurchaseNo    = PL.PurchaseNo 
				AND     PR.ActionStatus IN ('0','1','2')
				AND     IP.InvoiceId = '#URL.ID#' 
				AND     R.ReceiptNo = PR.ReceiptNo
				<!--- show not matched receipts here --->
				AND     (
				          PR.InvoiceIdMatched is NULL 
				          OR PR.InvoiceIdMatched NOT IN (
						                                 SELECT InvoiceId 
						                                 FROM   Invoice 
														 WHERE  InvoiceId = PR.InvoiceIdMatched
														 AND    Invoiceid != '#URL.ID#'
														 ) 
						)
				ORDER BY PL.PurchaseNo 
			</cfquery>	
							
		</cfif>				
		
		<cfoutput>
						
		<cfif Lines.recordcount eq "0">
		
			<tr><td colspan="#col#" class="line"></td></tr>
			<tr><td colspan="#col#" align="center" style="height:40px" class="labelmedium"><font color="gray">There are no lines to be shown in this view.</font></td></tr>
			<tr><td colspan="#col#" class="line"></td></tr>
		
		</cfif>
		
		</cfoutput>
		
		<!--- check if invoice is already posted --->								
						
		<cf_verifyOperational module = "Accounting" Warning = "No">
				
		<cfoutput query="Lines">
						
			<cfif operational eq "1">
								
				<!--- check if the invoice was posted with the receipt lines in GL if the invoice has indeed the status = 1 : posted --->
				
				<cfif Invoice.ActionStatus eq "1">					
						
					<cfquery name="CheckLedger" 
						datasource="AppsLedger" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
					    SELECT  H.ReferenceId AS InvoiceId, 
						        L.ReferenceId AS ReceiptId
		                FROM    TransactionHeader H, 
							    TransactionLine L 
						WHERE   L.Journal         = H.Journal 
						AND     L.JournalSerialNo = H.JournalSerialNo
		                AND     L.ReferenceId     = '#ReceiptId#'
						AND     H.TransactionCategory = 'Payables'
					</cfquery>
																															
					<cfif CheckLedger.recordcount gte "1">
					    <cfset st = "show">									
					<cfelse>					
					    <cfset st = "hide"> <!--- matched for other invoice already, do not allow matching --->													
					</cfif>	
				
				<cfelse>
				
																
					<cfquery name="CheckLedger" 
						datasource="AppsPurchase" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						SELECT  InvoiceIdMatched as InvoiceId,
						        ReceiptId
					    FROM    PurchaseLineReceipt 
						WHERE   ReceiptId = '#ReceiptId#' 							
					</cfquery>								
					
					<cfif CheckLedger.InvoiceId eq "" or CheckLedger.InvoiceId eq URL.ID>
					    <cfset st = "show">																														
					<cfelse>								    
					    <cfset st = "hide"> <!--- matched for other invoice already, do not allow matching --->
					</cfif>					
										
				</cfif>									
			
			<cfelse>
								    										
				<cfquery name="CheckLedger" 
					datasource="AppsPurchase" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT  InvoiceIdMatched as InvoiceId,
					        ReceiptId
				    FROM    PurchaseLineReceipt 
					WHERE   ReceiptId = '#ReceiptId#' 							
				</cfquery>	
																						
				<cfif CheckLedger.InvoiceId eq "" or CheckLedger.InvoiceId eq URL.ID>
				    <cfset st = "show">																														
				<cfelse>					
				    <cfset st = "hide"> <!--- matched for other invoice already, do not allow matching --->
				</cfif>						
									
			</cfif>					
								
			<cfif st eq "Show">
								
				<!--- receipt currency != invoice currency --->
				<cfif Currency neq Invoice.DocumentCurrency>
										
					<cfquery name="CheckCurrency" 
						datasource="AppsLedger" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
					    SELECT  *
		                FROM    CurrencyExchange C
						WHERE   Currency = '#Invoice.DocumentCurrency#' 
						AND     EffectiveDate <= '#Invoice.DocumentDate#'
						ORDER BY EffectiveDate DESC
					</cfquery>
					
																				
					<!--- show receipt amount expressed in the invoice currency --->
																							
					<cfset amt = ReceiptAmountBase*CheckCurrency.ExchangeRate>
														
				<cfelse>
												
					<cfset amt = ReceiptAmount>
													
				</cfif>
																		
				<cfif CheckLedger.ReceiptId eq ReceiptId and CheckLedger.InvoiceId neq "">
				    
					    <tr class="highlight4 line labelmedium" style="height:20px">
						<cfelse>
						<tr class="line labelmedium" style="height:20px">
						</cfif>
				    	<td height="18"></td>
						<td>#currentrow#.</td>
						<td style="padding-left:4px;border-left:1px solid silver">
						   #DateFormat(DeliveryDate,CLIENT.DateFormatShow)# / #PurchaseNo# <cfif PackingSlipNo eq "">/ <a href="javascript:receipt('#ReceiptNo#','view')">#ReceiptNo#</a><cfelse>/ #PackingslipNo#</cfif>
						</td>
						<td style="padding-left:4px;border-left:1px solid silver">
						
						<cfif warehouse neq "">
						
							<cfquery name="get" 
							datasource="AppsMaterials" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							    SELECT  *
				                FROM    Warehouse
								WHERE   Warehouse = '#warehouse#' 
						    </cfquery>
						
							#get.WarehouseName#								
						
						<cfelseif personno neq "">
						
							<cfquery name="get" 
							datasource="AppsEmployee" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							    SELECT  *
				                FROM    Person
								WHERE   PersonNo = '#personno#' 
						    </cfquery>
							
							#get.LastName#
						
						<cfelse>
						
							#officerLastName#								
							
						</cfif>								
						
						</td>								
						<td style="min-width:200px;padding-left:4px;border-left:1px solid silver">#left(ReceiptItem,40)#</td>
						<td style="padding-left:4px;border-left:1px solid silver">#ReceiptItemNo#</td>
					    <td align="right" style="max-width:60px;padding-left:4px;border-left:1px solid silver;padding-right:3px">#numberformat(ReceiptQuantity,',__')#</td>
						<td style="padding-left:4px;border-left:1px solid silver" align="center">#Invoice.DocumentCurrency#</td>
					    <td align="right" style="border-left:1px solid silver;padding-right:4px">
					    	<cftry>
					    		#NumberFormat(amt/ReceiptQuantity,",.__")#
					    	<cfcatch>
					    	</cfcatch>		
					    	</cftry>	
					    </td>
						<td align="right" style="border-left:1px solid silver;padding-right:4px">
						
						#NumberFormat(amt,",.__")#</td>
													
						<cfif Parameter1.InvoiceMatchPriceActual eq "1">								
						
							<td align="right" style="height:22;padding-left:1px;padding-right:1px;border-left:1px solid silver;width:80px">
																				
								<cfif invoice.actionStatus eq "0">		
							
								<cfinput name="prc#receiptid#" 
								 type="text" 
								 class="amount enterastab" 
								 onchange="_cf_loadingtexthtml='';ptoken.navigate('InvoiceMatchSetPrice.cfm?field=price&receiptid=#receiptid#&value='+this.value,'inv#receiptid#')"
								 style="padding-right:2px;height:19px;border:0px solid silver;background-color:ffffff;font-size:13px;text-align:right;width:100%" 
								 value="#NumberFormat(InvoicePrice,"_.__")#">
								 
								 <cfelse>								 								 								 
								 #NumberFormat(InvoicePrice,",.__")#								 
								 </cfif>
															
							</td>
							
							<td align="right" style="padding-right:3px;border-left:1px solid silver;width:80px">#numberformat(ReceiptTax*100,'._')#%</td>
							
							<td align="right" 
							    style="border-left:1px solid silver;padding-right:4px" 
								id="inv#receiptid#">#NumberFormat(InvoiceAmount,",.__")#</td>
								
						<cfelseif Parameter1.InvoiceMatchPriceActual eq "2">
						
							<td align="right" id="inv#receiptid#" style="height:21;padding-left:2px;padding-right:2px;border-left:1px solid silver;width:80px">														
								 #NumberFormat(InvoicePrice,",.__")#								 															
							</td>
							
							<td align="right" style="padding-right:3px;border-left:1px solid silver;width:80px">#numberformat(ReceiptTax*100,',._')#%</td>
							
							<td align="right" 
							    style="border-left:1px solid silver;padding-right:4px">
								
								<cfinput name="amt#receiptid#" 
								 type="text" 
								 class="amount enterastab" 
								 onchange="_cf_loadingtexthtml='';ptoken.navigate('InvoiceMatchSetPrice.cfm?field=amount&receiptid=#receiptid#&value='+this.value,'inv#receiptid#')"
								 style="padding-right:2px;height:19px;border:0px solid silver;background-color:ffffff;font-size:13px;text-align:right;width:80" 
								 value="#NumberFormat(InvoiceAmount,".__")#">
								 
							</td>		
							
						</cfif>
												
						<!--- invoice is not yet posted so allow to select --->
													
						<cfif invoice.actionStatus eq "0">								
							
							<cfif actionstatus eq "0">
							
							<td  align="center" style="background-color:d3d3d3;border:1px solid silver;padding-left:2px;padding-right:2px"></td>
							
							<cfelse>
							
							<td align="center" style="border:1px solid silver;padding-left:2px;padding-right:2px">
														
							   <input type="checkbox" class="enterastab myselect" value="'#ReceiptId#'" name="linesselect"
								 onClick="hl(this, this.checked)"
						        <cfif (CheckLedger.ReceiptId eq ReceiptId 
								    and CheckLedger.InvoiceId neq "")>checked</cfif>>
									
							</td>
									
							</cfif>		
						   
						<cfelse>  
						
							<td  align="center" style="border:1px solid silver;padding-left:2px;padding-right:2px">
							<cfif CheckLedger.ReceiptId eq ReceiptId and CheckLedger.InvoiceId neq "">
																
							<img src="#SESSION.root#/images/check_icon.gif" alt="Matched" border="0" align="absmiddle">
							
							</cfif>	
							</td>
							
						</cfif>	
							
						   
				    </tr>
															
					<cfif Currency neq Invoice.DocumentCurrency>
					
					<tr bgcolor="FDFEDE" class="labelmedium" style="height:20px">
					   <td colspan="5"></td>
					   <td colspan="2" style="font-size:10px;border-bottom:1px solid silver;border-left:1px solid silver;padding-left:4px"><cf_tl id="Receipt"><cf_tl id="Currency">:</td>
					   <td style="padding-left:4px;border-bottom:1px solid silver;border-left:1px solid silver" align="center">#Currency#</td>
					   <td style="padding-right:7px;padding-left:4px;border-bottom:1px solid silver;border-left:1px solid silver" align="right">#NumberFormat(ReceiptAmount/ReceiptQuantity,",.__")#</td>							   
					   <td style="padding-left:4px;border-bottom:1px solid silver;border-right:1px solid silver;border-left:1px solid silver;padding-right:4px" align="right">#NumberFormat(ReceiptAmount,",.__")#</td>
					   <td></td>
					</tr>
					
				   </cfif>
								
			</cfif>
			
		</cfoutput>
		
		</table>
	</td></tr>
</table></td>
</tr>	

<cfif invoice.actionStatus eq "0">

	<!--- -store receipts from a deeper iframe level-- --->
    <input type="hidden" name="receipt" id="receipt">
			
	<tr><td height="4" colspan="2" id="match">

		<!--- -store receipts from a deeper iframe level-- --->
	    <input type="hidden" name="receipt" id="receipt">
	    <!--- ------------------------------------------- --->
	    <!--- select the matched receipts to this invoice --->
		<!--- ------------------------------------------- ---> 
							
	</td></tr>

	<script>
		total('initial')
	</script>
	
</cfif>	
		
<!--- allow for posting otherwise the default option below applies --->

<cfif Action.InvoiceWorkflow eq "0">
		
	<tr><td height="27" colspan="2" align="center" style="padding-top:5px">
	
		<input type="button" class="button10g" name="Close" id="Close" value="Close" onclick="parent.window.close()">
		
		<cfif operational eq "1">
		
			<cfquery name="Ledger" 
		    datasource="AppsLedger" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
			    SELECT   * 
				FROM     TransactionHeader
				WHERE    ReferenceId = '#URL.ID#' 
			</cfquery>
			
			<!--- allow deletion of the transaction is not processed yet --->			
			<cfif Ledger.Amount eq Ledger.AmountOutstanding>
				<input type="submit" class="button10g" name="Purge" id="Purge" value="Remove">
			</cfif>	
			
		<cfelse>
			<input type="submit" class="button10g" name="Purge" id="Purge" value="Remove">
		</cfif>	
						
		<!--- invoice is posted if the amounts are fully matched with the receipt --->
		
		<input type="submit" class="hide" name="Save" id="Save" value="Post Invoice">
		
    </td></tr>
	
<cfelse>
		
    <!--- just a provision to process receipt in case the workflow is required --->
			
	<tr class="hide"><td height="11" colspan="2" align="center" valign="top">
															
		<!--- invoice is posted if the amounts are fully matched with the receipt --->				
						
		<input type  = "submit" 
		       class = "hide" 
			   style = "width:250px" 
			   id    = "Save" 
			   name  = "MatchReceipt" 
			   value = "Match Receipt to this payable">
				 
    </td></tr>	

</cfif>
