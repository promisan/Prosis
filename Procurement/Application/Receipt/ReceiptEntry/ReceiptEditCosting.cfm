
<cfparam name="url.presentation" default="0">

<cfquery name="Receipt" 
 datasource="AppsPurchase" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	 SELECT *
	 FROM   Receipt
	 WHERE  ReceiptNo = '#URL.ID#'
</cfquery>

<table width="100%" align="center" style="padding:2px">
								 					 
		 <!--- -------------------------- --->
		 <!--- -------direct costs------ --->
		 <!--- ------------------------- --->
		 
		 <cfquery name="CheckLines" 
		 datasource="AppsPurchase" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			 SELECT RL.*, OrderUoMVolume
			 FROM  PurchaseLineReceipt RL INNER JOIN PurchaseLine PL ON PL.RequisitionNo = RL.RequisitionNo 
			 WHERE RL.ReceiptNo    = '#Receipt.ReceiptNo#'
			 AND   RL.ActionStatus <> '9' and PL.actionStatus <> '9'
		 </cfquery>
		 
		 <!--- --------------- --->
		 <!--- ASSOCIATED COST --->
		 <!--- --------------- --->
		  
		 <cfquery name="getJournal" 
		 datasource="AppsLedger" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			 SELECT * 
			 FROM   Journal 
			 WHERE  Mission = '#receipt.mission#' 
			 AND    SystemJournal = 'Receipt'			
		 </cfquery>		
		 
		 <cfif getjournal.recordcount eq "0">
		    <cfset cl = "hide">
		 <cfelse>
		 	<cfset cl = "regular"> 
		 </cfif>
		 
		 <!--- --------------- --->
		 <!--- --DIRECT COST-- --->
		 <!--- --------------- --->
		 		 
		 <tr class="<cfoutput>#cl#</cfoutput> line">
		 
		 	<td colspan="4" style="padding-left:8px" class="labelmedium">			
			    <table style="width:100%">
				<tr>
				<td class="labelmedium fixlength" bgcolor="white" style="font-size:22px;min-width:200px;padding:3px;padding-left:7px;">
				<cf_tl id="Received items and value"></td>
				
				<td>
				<td align="right" style="padding:4px;padding-left:20px;width:100px;background-color:ffffff">
						
				    <table>
					<tr><td  style="cursor: pointer;border:1px solid silver">
					 <input class="regularxxl" 
					     title="Search for receipt line" 
						 style="border:0px solid silver;background-color:ffffff;padding-left:3px" 
						 id="inputline" name="inputline">
					</td>
					<td style="cursor: pointer;border:1px solid silver">	
					<cfoutput>				
					<img src="#SESSION.root#/Images/search.png" alt="Find" 					   
					   border="0" height="24" width="26" id="refreshreceipt" align="absmiddle"
					   onclick="_cf_loadingtexthtml='';Prosis.busy('yes');ptoken.navigate('../ReceiptEntry/ReceiptDetail.cfm?mode=receipt&rctId=#checkLines.receiptid#&reqno=#checkLines.requisitionno#&box=i#Receipt.ReceiptNo#&search='+document.getElementById('inputline').value,'i#Receipt.ReceiptNo#')">							   
					   </cfoutput>	
					</td>
					</tr>
					</table>
							   
				</td>											
				</tr>
				</table>
				</td>		
			</td>
			
			<cfquery name="Volume" dbtype="query">
				 SELECT count(*) as Lines, SUM(ReceiptVolume) as Volume
				 FROM   CheckLines
			</cfquery>
			
			<td align="right" style="padding-right:7px" colspan="1" class="labellarge">
			   <table>
			   <tr>
			    <td class="fixlength"><cf_tl id="Lines">:</td>
			   <td align="right" bgcolor="FFFFFF" class="labelmedium" id="volumedirect" style="font-size:18px;padding:3px;width:60">
			   <cfoutput>#Volume.Lines#</cfoutput>
			   </td>
			   <td class="fixlength" style="padding-left:10px"><cf_tl id="Volume">:</td>
			   <td align="right" bgcolor="FFFFFF" class="labelmedium" id="volumedirect" style="font-size:18px;padding:3px;width:100">
			   <cfoutput>#numberformat(Volume.volume,",.__")#</cfoutput>
			   </td>
			   </tr>
			   </table>
			</td>
			
			<cfif editmode eq "Edit">
			
				<cfquery name="Currency" dbtype="query">
					 SELECT DISTINCT Currency
					 FROM   CheckLines
				</cfquery>
				
				<td align="right" style="padding-right:7px" class="labellarge">
					<table>
						   <tr>
						   <td class="fixlength"><cf_tl id="Current exchange rate">:</td>
						   
						   <cfoutput query="Currency">
						   
						   <td style="padding-left:5px">#Currency#</td>
						  
						    <cfquery name="getExchange" 
							 datasource="AppsLedger" 
							 username="#SESSION.login#" 
							 password="#SESSION.dbpw#">
								 SELECT * 
								 FROM   CurrencyExchange 
								 WHERE  Currency = '#currency#' 			
								 ORDER BY EffectiveDate DESC
						    </cfquery>	
							
							<td style="padding-left:3px">#numberformat(getExchange.exchangerate,'.,____')#</td>	 
							<td id="apply#currency#" style="padding-left:4px">
								<a href="javascript:_cf_loadingtexthtml='';Prosis.busy('yes');ptoken.navigate('setReceiptExchangeRate.cfm?receiptno=#CheckLines.receiptno#&currency=#currency#','apply#currency#')">
								<cf_tl id="Apply">
								</a>
							</td>						    
						   
						   </cfoutput>
						   
						   </tr>
					</table>	   
				</td>
			
			<cfelse>
			
				<td></td>
			
			</cfif>
			
			
			<cfquery name="DirectCost" dbtype="query">
				 SELECT SUM(ReceiptAmountBase) as Total
				 FROM   CheckLines
			</cfquery>
			  
			<td align="right" colspan="3" style="padding-right:7px" class="labellarge">
			  
			   <table>
				   <tr class="labelmedium">
				   <td class="fixlength"><cf_tl id="Purchase">:</td>
				   <td align="right" bgcolor="FFFFFF" id="totaldirect" style="width:140;border:0px solid silver">
				    <cfoutput>#numberformat(DirectCost.total,",.__")#</cfoutput>
				   </td>
				   </tr>
				   
					<cfquery name="cost" 
					datasource="AppsPurchase" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					   SELECT    *
					   FROM     ReceiptCost			  
					   WHERE    ReceiptNo = '#Receipt.ReceiptNo#'  			   
					</cfquery>
					
					<cfoutput query="cost">
										
						<cfquery name="CostTotal" 
						datasource="AppsPurchase" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT   SUM(AmountCost) as AmountCost
							FROM     PurchaseLineReceiptCost
							WHERE    ReceiptId IN (SELECT ReceiptId 
							                       FROM   PurchaseLineReceipt
												   WHERE  ReceiptNo = '#Receipt.ReceiptNo#'
												   AND    ActionStatus != '9')													   
							AND      CostId = '#CostId#'			
					  </cfquery>
											  
					  <cfif costTotal.AmountCost gt "0">					  
					
						   <tr class="labelmedium" style="height:15px">
						   <td>#description#</td>							
						   <td align="right" style="padding-left:5px;">#numberformat(CostTotal.AmountCost,',.__')#</td>												   
						   </tr>					   
			  
					  </cfif> 
				   
					</cfoutput>
					
			   </table>	
			   
			</td>	
							 
		 
		 </tr> 		
		
						
		 <cfif directCost.total eq "">
		    <cfset  direct = 0>
		 <cfelse>
		 	<cfset  direct = directCost.total>	 
		 </cfif>
		 		 			 
		 <cfif checkLines.recordcount gt "0" and url.presentation neq "9">				 	
											 
			 <tr>			
			
			 <td colspan="7" style="padding-left:4px;padding-right:9px">
			 			
				 <table width="100%" align="center" bgcolor="ffffff">
				 	<tr><td style="padding-left:1px" id="i<cfoutput>#Receipt.ReceiptNo#</cfoutput>">
																																			
							<cfset url.mode     = "receipt">
							<cfset url.box      = "i#Receipt.ReceiptNo#">																		
							<cfset url.reqno    = "#checkLines.requisitionno#">
							<cfset url.rctid    = "#checkLines.receiptid#">
							<cfinclude template = "../ReceiptEntry/ReceiptDetail.cfm">							
												
					 </td></tr>
				 </table>
				 
			 </td>
			 </tr>
			 			 		
		 </cfif>	
		 
		 <!--- --------------- --->
		 <!--- ASSOCIATED COST --->
		 <!--- --------------- --->
		  
		 <cfquery name="getJournal" 
		 datasource="AppsLedger" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			 SELECT * 
			 FROM   Journal 
			 WHERE  Mission = '#receipt.mission#' 
			 AND    SystemJournal = 'Receipt'		
			
		 </cfquery>				
				 
		 <cfif getJournal.recordcount gte "1">	 		 
			 		 		 
		 <tr><td colspan="7" style="background-color:f1f1f1;padding-left:21px;padding-right:30px;height:20px">
		 		 		 		 
			  	<cf_LedgerTransaction
				 mission              = "#receipt.mission#"
				 journal              = "#valueList(getJournal.Journal)#" 
			     TransactionSource    = "ReceiptSeries" 			 
				 TransactionSourceNo  = "#Receipt.ReceiptNo#"
				 editmode             = "#editmode#"
				 label                = "Cost"
				 debitcredit          = "Debit"
				 function             = "receiptcost">
		 
		 </td></tr>
		 
		 <tr class="line">
		 
		    <td colspan="6" style="padding-left:9px">
		 
			    <table>
				<tr class="labelmedium" style="height:20px">
				<td bgcolor="white" style="width:200px;padding-left:7px;border:0px solid silver"><cf_tl id="Associated costs"></td>
				</tr>
				</table>
			
			</td>		 
			
		    <td align="right" style="padding-right:30px">
				 <table>
				  <tr class="labelmedium"><td align="right" style="height:20px;width:140;" id="totalother"></td></tr>
				  </table>		
			</td>		
		 
		 </tr>
		 
		 </cfif>		
						
</table>

<CFOUTPUT>
<script>
	Prosis.busy('no')
    ptoken.navigate('setReceiptTotal.cfm?mission=#receipt.mission#&receiptno=#receipt.receiptno#','process')	
</script>
</CFOUTPUT>