<cfparam name="url.addressid"  default="00000000-0000-0000-0000-000000000000">
<cfparam name="url.scope"  default="settlement">

<cfif URL.addressid eq "">
	<cfset URL.addressid = "00000000-0000-0000-0000-000000000000">
</cfif>

<cfquery name="getSettle"
 datasource="AppsTransaction" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 	SELECT    SE.*, 
	          S.Mode, S.Description 
	FROM      Settle#url.warehouse# SE INNER JOIN Materials.dbo.Ref_Settlement S ON SE.SettleCode = S.Code
	WHERE     RequestNo = '#url.RequestNo#'    
</cfquery> 

<cfif url.scope neq "workflow" and url.scope neq "standalone">

	<cfquery name="getSale"
 	datasource="AppsMaterials" 
 	username="#SESSION.login#" 
 	password="#SESSION.dbpw#">
	 	SELECT    SalesCurrency, 
			  	  SUM(SalesTotal) as sTotal
		FROM      vwCustomerRequest
		WHERE     RequestNo = '#url.RequestNo#' 				
		GROUP BY  SalesCurrency
	</cfquery>
	
	<cfset vPreviousSettlement = 0>
	
<cfelse>
	
	<cfquery name="qBatch" 
  	datasource="AppsMaterials" 
  	username="#SESSION.login#" 
  	password="#SESSION.dbpw#">	
		SELECT *
		FROM   Materials.dbo.WarehouseBatch B 
	 	WHERE  B.BatchId = '#URL.BatchId#'
	</cfquery> 	
	
	<cfquery name="getSale"
	 datasource="AppsMaterials" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 SELECT   ITS.SalesCurrency, 
			  	  SUM(ITS.SalesTotal) as sTotal
		 FROM     ItemTransaction IT INNER JOIN ItemTransactionShipping ITS ON
		 	      IT.TransactionId = ITS.TransactionId
		 WHERE    IT.TransactionBatchNo = '#qBatch.BatchNo#'
		 GROUP BY ITS.SalesCurrency	
	</cfquery>	
	
	<cfquery name="getSettlement" 
  	datasource="AppsMaterials" 
  	username="#SESSION.login#" 
  	password="#SESSION.dbpw#">		
		SELECT     Currency as SettleCurrency, 
		           SUM(Amount) as sTotal
		FROM       Accounting.dbo.TransactionHeader
		WHERE      TransactionSourceId = '#qBatch.Batchid#' 
		AND        Reference           = 'Settlement' 
		AND        RecordStatus       <> '9' 
		AND        ActionStatus       <> '9'	
		GROUP BY   Currency
	</cfquery>
			
	<cfif getSettlement.recordcount eq 0>
		<cfset vPreviousSettlement = 0>
	<cfelse>	
		<cfset vPreviousSettlement = getSettlement.sTotal>
	</cfif>		
	
</cfif>	 

<cfif getSale.sTotal eq "0">
	
	<script>
		alert("Sales with no amount were recorded. Operation aborted.")
	</script>

</cfif>

<cfoutput>

<cfquery name="Warehouse" 
  	datasource="AppsMaterials" 
  	username="#SESSION.login#" 
  	password="#SESSION.dbpw#">	
		SELECT *
		FROM   Warehouse
	 	WHERE  Warehouse = '#URL.Warehouse#'
	</cfquery> 	

<table id="tsettlement" name="tsettlement" align="center" width="100%" height="100%" class="navigation_table">

<tr class="line settlement_title">
	
	<td style="width:20px"></td>
	<td style="width:20px"></td>
	<td width="55%" style="font: medium Calibri;"><cf_tl id="Type"></td>	
	<td align="right" style="font: medium Calibri;"></td>
	<td width="15%" align="right" style="font: medium Calibri;"><cf_tl id="Amount"></td>
	<td width="15%" align="right" style="font: medium Calibri;">#getSale.SalesCurrency#</td>
	<td width="2%"></td>		
</tr>

<cfset vTotal = 0>
<cfset vTotal_Cash = 0>

<cfif getSale.recordcount eq "0">
	
	<script>
	  ptoken.navigate("#SESSION.root#/Warehouse/Application/SalesOrder/POS/Sale/applyCustomer.cfm?warehouse=#url.warehouse#",'customerbox')		
	 try { ProsisUI.closeWindow('wsettle',true)} catch(e){};
	</script>  

<cfelse>

	<cfloop query = "getSettle">
	
		<tr class="line_details navigation_row labelmedium line" height="30">
				
		<td style="padding-left:10px;padding-right:7px">#currentrow#.</td>
		<td style="padding-right:7px;padding-top:1px">
		
		<img src="#SESSION.root#/images/delete5.gif" 
		     alt="#lt_text#" 
			 border="0" 
			 width="16" height="16"
			 style="cursor:pointer" 
			 class="navigation_action"
		     onclick="_cf_loadingtexthtml='';deletesettlement('#url.warehouse#','#url.customerid#','#getSettle.TransactionId#','#url.terminal#','#url.batchid#','#url.td#','#url.th#','#url.tm#','#Mode#')">
				
		</td>
		<td>#Description#</td>
		<td align="right" style="font-size:13px">#SettleCurrency#</td>
		<td align="right" style="padding-left:5px;font: large Calibri;">#NumberFormat(SettleAmount, ',.__')# </td>
		<td align="right">
	 
			<cfif SettleCurrency neq getSale.SalesCurrency>
			
				<cfset exc = 0.00>
				<cf_exchangerate CurrencyFrom = "#SettleCurrency#" CurrencyTo = "#getSale.SalesCurrency#">
				<cfset vConverted_Amount = round(SettleAmount/exc * 100 )/ 100>		
				
			<cfelse>
			
				<cfset vConverted_Amount = SettleAmount>	
				
			</cfif>	
			
			<cfif Mode eq "Cash">
			
				<cfset vTotal_Cash = vTotal_Cash + vConverted_Amount>
				
			</cfif>
			
			#NumberFormat(vConverted_Amount, ',.__')#	
			
			<cfset vTotal = vTotal + vConverted_Amount>		
			
		</td>
		<td></td>
		</tr>
		
		<tr style="height:1px">
		<td></td>
		<td colspan="6">
		
			<cfswitch expression="#Mode#">
			
				<cfcase value="Gift">
					#PromotionCardNo#	
				</cfcase>
				<cfcase value="Credit">
					<table width="100%" class="formpadding">
						<tr style="background-color:ffffaf" class="labelit"><td>#CreditCardNo#&nbsp;<cf_tl id="Expiry">: #ExpirationMonth#/#ExpirationYear# &nbsp;&nbsp;<cf_tl id="Approval">: #ApprovalCode#</td></tr>									
					</table>
				</cfcase>
				<cfcase value="Check">
					<table width="100%" class="formpadding">
						<tr style="background-color:eaeaea" class="labelit"><td>#BankName#&nbsp;<cf_tl id="Check No">: #ApprovalReference#  &nbsp;Approval: #ApprovalCode#</td></tr>									
					</table>
				</cfcase>
			
			</cfswitch>
		</td>		
		</tr>
				
	</cfloop>
	
	<cfset vTotal = vTotal + vPreviousSettlement>
	
	<cfquery name="getDiscounted" dbtype="query">
		SELECT 	SUM(SettleAmount) SettleAmount
		FROM 	getSettle
		WHERE	Mode = 'Gift'
	</cfquery>
		
	<cfset vDiscount = 0>
	
	    <cfif getDiscounted.recordCount gt 0>
			<cfset vDiscount = getDiscounted.SettleAmount>
		</cfif>
		
		<tr><td colspan="7" class="line"></td></tr>	
		<tr class="settlement_title" height="50">		
			<td colspan="5" align="right" style="padding-left:20px;font: large Calibri;"><cf_tl id="Discounted"></td>
			<td align="right" style="font: large Calibri;">#NumberFormat((vTotal - vDiscount), ',.__')# </td>
			<td></td>
		</tr>
		
		<cfif vDiscount gt 0>
			<tr><td colspan="7" class="line"></td></tr>	
			<tr class="settlement_title" height="45">
				<td colspan="5" align="left" style="padding-left:20px;font: large Calibri;"><cf_tl id="Discounted"></td>
				<td align="right" style="font: large Calibri;">#NumberFormat(vDiscount, ',.__')# </td>
				<td></td>
			</tr>
		</cfif>
		
		<cfset vPending = getSale.sTotal - vTotal>
		
		<cfif vPending gt 0>
			<tr><td colspan="7" class="line"></td></tr>	
			<tr class="settlement_title" height="45">
				<td colspan="5" align="left" style="padding-left:20px;font: large Calibri;"><cf_tl id="Pending"></td>
				<td align="right" style="font: large Calibri; color:red">#NumberFormat(vPending, ',.__')# </td>
				<td></td>
			</tr>
		</cfif>
		
		<tr><td colspan="7" class="line"></td></tr>			
		<tr height="45">
			<td colspan="5" align="right" style="padding-right:20px" class="labellarge"><cf_tl id="Total"></td>
			<td align="right" class="labellarge" style="font-size:30px">#NumberFormat(getSale.sTotal, ',.__')#
			 </td>
			<td></td>
		</tr>
		
		<cfif ABS(vTotal-getSale.sTotal) gte 0.01>
		
			<cfif getSale.recordcount gt 0>
				<cfset vRemaining = vTotal_Cash - (getSale.sTotal - (vTotal - vTotal_Cash) ) >
			<cfelse>
				<cfset vRemaining = 0>
			</cfif>		
			
			<cfquery name="qClear"
			 datasource="AppsTransaction" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
				 DELETE FROM Settle#URL.Warehouse#	
				 WHERE  RequestNo = '#url.requestNo#'				
				 AND    SettleAmount < 0		
			</cfquery> 	
			
			<cfif vRemaining gt 0.00>		
				
				<cfquery name="getMode"
				 datasource="AppsQuery" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
				 	SELECT    Code 
					FROM      Materials.dbo.Ref_Settlement
					WHERE     Mode = 'Cash' 
				</cfquery> 			
				
				<cfquery name="qCheck"
				 datasource="AppsTransaction" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
				 	 SELECT  *
					 FROM    Settle#URL.Warehouse#
	 				 WHERE   RequestNo      = '#url.RequestNo#'
		 			 AND     SettleCode     = '#getMode.Code#'		
					 AND     SettleCurrency = '#getSale.SalesCurrency#'	 	 			
				</cfquery> 	 
	
				<cfif qCheck.recordCount eq 0>
				
					<cfquery name="qInsert"
					 datasource="AppsTransaction" 
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">
						 INSERT INTO Settle#URL.Warehouse# 
						      (RequestNo,
							   CustomerId,
						       AddressId,
						       SettleCode,					 
						       SettleCurrency,
						       SettleAmount )
						 VALUES ('#url.RequestNo#',
						         '#url.customerid#',
						 		'#url.addressid#',
								'#getMode.Code#',					
								'#getSale.SalesCurrency#',
								'#-1*vRemaining#')
					</cfquery>
					
				<cfelse>
				
					<cfquery name="qUpdate"
					 datasource="AppsTransaction" 
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">
						 UPDATE Settle#URL.Warehouse#
						 SET    SettleAmount 	  = '#-1*vRemaining+qCheck.SettleAmount#',
						 		ApprovalReference =  '#vRemaining#' 
						 WHERE  Requestno 		  = '#url.Requestno#'
						 AND    SettleCode 		  = '#getMode.Code#'
						 AND    SettleCurrency    = '#getSale.SalesCurrency#'	 	 				 
					</cfquery> 	
					
				</cfif>	 
						
				<tr><td colspan="7" class="linedotted"></td></tr>	
				<tr height="50">
					<td colspan="5" align="left" style="padding-left:20px" class="labellarge"><cf_tl id="Cash back"></td>
					<td align="right" style="font-size:34px">
						<font color="0080C0">#NumberFormat(vRemaining, ',.__')#
					</td>
					<td></td>
				</tr>	
			
			</cfif>
			
		</cfif>	
		
		
		<cfif NumberFormat(vTotal, '.__') gte NumberFormat(getSale.sTotal, '.__') or (URL.scope eq "standalone" and vTotal gt 0)>
		
			<tr><td colspan="7" class="linedotted"></td></tr>	
			
			<tr><td colspan="7" height="10"></td></tr>	
				
			<tr class="settlement_title" height="100%">
				
					<td colspan="7" align="center" valign="bottom" style="padding-bottom:10px">
										
					<cf_tl id="Invoice"    var="label1">
					<cf_tl id="Electronic" var="label2">
					<cf_tl id="Manual"     var="label3">
					<cf_tl id="FEL" var="label4">
								
					<cfquery name="getInvoiceSale"
					 datasource="AppsMaterials" 
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">
					 	SELECT  R.*
						FROM    vwCustomerRequest R
						WHERE   CustomerIdInvoice IN (SELECT CustomerId FROM Materials.dbo.Customer WHERE CustomerId = R.CustomerIdInvoice)
						AND     RequestNo = '#url.requestNo#'												
					</cfquery> 
					
					<cfif getInvoiceSale.recordcount gte "1">
								
						<cfset customeridinvoice = getInvoiceSale.CustomerIdInvoice>
						
					<cfelse>
					
						<cfset customeridinvoice = url.customerid>
						
					</cfif>					
										
					<cfquery name="getWarehouseJournal"
						 datasource="AppsMaterials" 
						 username="#SESSION.login#" 
						 password="#SESSION.dbpw#">
						 	SELECT  *
							FROM    WarehouseJournal
							WHERE   Warehouse = '#url.warehouse#'
							AND		Area      = 'SETTLE'
							AND		Currency  = '#getSale.SalesCurrency#'
					</cfquery> 
					
					<cfif getWarehouseJournal.TransactionMode eq "2">
					
						<cfif getSale.sTotal neq "0">
						
						      <cfquery name="Tax" 
							  datasource="AppsSystem" 
							  username="#SESSION.login#" 
							  password="#SESSION.dbpw#">
								    SELECT *
									FROM   Organization.dbo.Ref_Mission
									WHERE  Mission = '#warehouse.Mission#'												   
						   </cfquery>
						  				
						   <cfif tax.EDIMethod neq "">		   
						 
								<cfquery name="getTaxUnit"
									datasource="AppsMaterials"
									username="#SESSION.login#"
									password="#SESSION.dbpw#">
										SELECT TaxOrgUnitEDI
										FROM WarehouseTerminal
										WHERE TerminalName='#url.terminal#'
								</cfquery>
	
								<cfquery name="qSeriesCheck"
										datasource="AppsOrganization"
										username="#SESSION.login#"
										password="#SESSION.dbpw#">
										SELECT  *
										FROM    OrganizationTaxSeries
										WHERE   OrgUnit = '#getTaxUnit.TaxOrgUnitEDI#'
										AND     SeriesType = 'Invoice'
										AND     Operational = 1
										ORDER BY Created DESC
								</cfquery>
	
								<cfif qSeriesCheck.SubmissionMode eq "2">
								
									<!--- legacy layout based on IransactionLineShipping --->
								
									<cf_button2
										text		 = "#label4#"
										subtext		 = "#label1#"
										id			 = "postsettlementbutton1"
										bgColor		 = "##52b3d9"
										textsize	 = "24px"
										subtextsize	 = "15px"
										height		 = "80px"
										width		 = "200px"
										textColor	 = "##F2F2F2"
										borderRadius = "5px"
										onclick	     = "postsettlement('#url.warehouse#','#url.customerid#','#customeridinvoice#','#getSale.SalesCurrency#','#url.batchid#','#url.terminal#','#url.td#','#url.th#','#url.tm#','2','#url.addressid#','#url.requestno#')">
										
								<cfelse>
								
									<!--- we take new default mode --->
									
									<cf_button2
											text		 = "#label2#"
											subtext		 = "#label1#"
											id			 = "postsettlementbutton1"
											bgColor		 = "##52b3d9"
											textsize	 = "24px"
											subtextsize	 = "15px"
											height		 = "80px"
											width		 = "200px"
											textColor	 = "##F2F2F2"
											borderRadius = "5px"
											onclick	     = "postsettlement('#url.warehouse#','#url.customerid#','#customeridinvoice#','#getSale.SalesCurrency#','#url.batchid#','#url.terminal#','#url.td#','#url.th#','#url.tm#','3','#url.addressid#','#url.requestno#')">
								</cfif>
							
							</cfif>

						</cfif>
						
							<cf_button2
							text		 = "#label3#" 
							subtext		 = "#label1#"
							id			 = "postsettlementbutton2"  
							bgColor		 = "##03c9a9"
							textsize	 = "24px" 
							subtextsize	 = "15px" 
							height		 = "80px"
							width		 = "200px"							
							textColor	 = "##F2F2F2"
							borderRadius = "5px"
							onclick	     = "postsettlement('#url.warehouse#','#url.customerid#','#customeridinvoice#','#getSale.SalesCurrency#','#url.batchid#','#url.terminal#','#url.td#','#url.th#','#url.tm#','1','#url.addressid#','#url.requestno#')">
							
					<cfelse>		
							
							<cf_tl id="Tender" var="1">
							<cf_button2
							text		 = "#label1#" 
							subtext		 = "#lt_text#"
							id			 = "postsettlementbutton"  
							bgColor		 = "##03c9a9"
							textsize	 = "24px" 
							subtextsize	 = "15px" 
							height		 = "80px"
							width		 = "200px"							
							textColor	 = "##F2F2F2"
							borderRadius = "5px"
							onclick	     = "postsettlement('#url.warehouse#','#url.customerid#','#customeridinvoice#','#getSale.SalesCurrency#','#url.batchid#','#url.terminal#','#url.td#','#url.th#','#url.tm#','1','#url.addressid#','#url.requestno#')">							
					</cfif>		
											   
					</td>
			 </tr>	
				
			 <tr class="hide"><td colspan="settlementprocessbox"></td></tr>	
			 
		<cfelse>
		
			<tr><td height="100%"></td></tr>	 
		 
		 </cfif>
		
		<!--- </cfif> --->

</cfif>
	
</table>

</cfoutput>

<cfif url.scope neq "workflow" and url.scope neq "standalone">
	<cfset ajaxonload("doHighlight")>
<cfelse>
	<script>
		doHighlight();
	</script>	
</cfif>	
