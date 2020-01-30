
<cfparam name="Form.selected" default="">

<!--- filter condition on billing --->

<form name="transactionform" method="post">
	<cfoutput>	
	<input type="hidden"  id="selected" name="selected" value="#Form.Selected#">
	</cfoutput>
</form>

<!--- ----set the transaction for sales---- --->

<cfif Form.Selected neq "">
	
	<cfquery name="setReadyShipping" 
		  datasource="AppsMaterials" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">		  
		  UPDATE  WarehouseBatch
		  SET     BillingStatus  = '1',
		          BillingOfficerUserId    = '#SESSION.acc#',
				  BillingOfficerLastName  = '#SESSION.last#',
				  BillingOfficerFirstName = '#SESSION.first#',
				  BillingOfficerDate      = getDate()
		  WHERE   BatchNo IN (#preservesingleQuotes(Form.Selected)#)	 
		  AND     Warehouse = '#url.warehouse#'
	</cfquery>

</cfif>

<!--- ---------------------------------- --->
  
<cfquery name="Warehouse" 
	  datasource="AppsMaterials" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">		  
	  SELECT * 
	  FROM   Warehouse
	  WHERE  Warehouse = '#url.warehouse#'	  
</cfquery>		

<!--- get the billable transactions by Batch --->

<cfquery name="getPending" 
	  datasource="AppsMaterials" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">	  
	  
	  SELECT     B.BatchNo, 
	             B.TransactionDate, 
				 R.Description as TransactionTypeName,
				 WL.Description, 
				 WL.OrgUnitOperator,
				 B.BillingOfficerFirstName,
				 B.BillingOfficerLastName,
				 B.BillingOfficerDate,
				 (SELECT OrgUnitName FROM Organization.dbo.Organization WHERE OrgUnit = WL.OrgUnitOperator) as OrgUnitName,
				 T.ItemNo, 
				 T.ItemDescription, 
				 T.TransactionUoM, 
				 U.UoMDescription,
				 SUM(- (1 * T.TransactionQuantity)) AS TransactionQuantity,
				 MAX(S.SalesPriceFixed) as SalesPriceFixed,
				 MAX(S.SalesPriceVariable) as SalesPriceVariable,				 
				 SUM(S.SalesAmount) as SalesAmount

	  FROM       ItemTransaction AS T 
	  		     INNER JOIN WarehouseBatch AS B ON T.TransactionBatchNo = B.BatchNo 
				 INNER JOIN ItemUoM AS U ON T.ItemNo = U.ItemNo AND T.TransactionUoM = U.UoM 
				 INNER JOIN Ref_TransactionType R ON B.TransactionType = R.TransactionType 
				 INNER JOIN WarehouseLocation WL ON T.Warehouse = WL.Warehouse AND T.Location = WL.Location 
				 INNER JOIN ItemTransactionShipping S ON T.TransactionId = S.TransactionId
				 
	  WHERE      B.Mission   = '#url.mission#'
	  AND        B.Warehouse = '#url.warehouse#'
	  
	  <!--- status is approved = 1 --->
	  AND        B.ActionStatus = '1'
	  	  
	  AND        B.BillingStatus = '1'
	  
	  AND        T.BillingMode = 'External'
	  	  	  
	  <!--- for billing we only take the outgoing negative transactions for now --->
	  AND        (( B.TransactionType = '8' and TransactionQuantity < 0) OR B.TransactionType = '2')
	  
	  <!--- and not invoiced yet --->
	  AND     T.TransactionId IN  (
				  SELECT   TransactionId
                  FROM     ItemTransactionShipping S
                  WHERE    TransactionId = T.TransactionId 
				  AND      (
				            InvoiceId IS NULL OR 
							InvoiceId NOT IN (SELECT InvoiceId FROM Purchase.dbo.Invoice WHERE InvoiceId = S.InvoiceId)
						   )
				 )		
	 	    							
      GROUP BY    B.BatchNo, 
	              WL.OrgUnitOperator,
				  B.BillingOfficerFirstName,
				  B.BillingOfficerLastName,
				  B.BillingOfficerDate,
	              B.TransactionDate, 
				  S.SalesPriceFixed,
				  S.SalesPriceVariable,
				  S.SalesPrice,
				  R.Description, 
				  T.ItemNo, 
				  T.ItemDescription, 
				  T.TransactionUoM, 
				  U.UoMDescription, 
				  WL.Description
				  
	  ORDER BY    B.BatchNo			  
	  						
</cfquery>		


<cfif getPending.recordcount eq "0">

	<table width="100%">
	
	<tr><td class="linedotted"></td></tr>
	<tr><td align="center" height="40">

	    <cfoutput>	
   			<font face="Calibri" size="3" color="gray"><i>No transactions were selected.
			<a href="javascript:ColdFusion.navigate('../Shipping/PendingTransaction/Pending.cfm?systemfunctionid=#url.systemfunctionid#&mission=#URL.Mission#&warehouse=#url.warehouse#','contentbox1')"><font color="0080C0">Press here to return</font></a>
		</cfoutput>
	
	</td>
	</tr>
	<tr><td class="linedotted"></td></tr>
	
	</TABLE>
	
	<cfabort>

</cfif>

<!--- determine the price --->

<table width="98%" align="center" style="border:0px dotted silver;">

	<tr><td height="5"></td></tr>
	
	<tr><td id="invoiceprocess"></td></tr>

	<tr class="labelit">
      <td></td>
	  <td style="padding-left:3px">Batch</td>   
	  <td width="10%">Date</td>	
	  <td width="10%">Transaction</td>
	  <td width="20%">Location</td>
	  <td width="20%">Product</td>   
	  <td align="right">Qty</td>	
	  <td align="right">Fixed</td> 
	  <td align="right">Variable</td>
	  <td align="right">Total</td>		  
	 </tr>
	 
	 <cfset tot = "0">

	<cfoutput query="getPending" group="OrgUnitOperator">
	
	<tr><td style="height:30" class="labelmedium"><b>#OrgUnitName#</td></tr>
	<tr><td colspan="10" class="linedotted"></td></tr>
		
	<cfoutput>	

		<tr class="cellcontent">
		
			<td width="30" align="center">#currentrow#.</td>
						
			<td style="padding-left:3px;padding-right:3px">
			<a href="javascript:batch('#BatchNo#','#url.mission#','process','#url.systemfunctionid#','')"><font color="0080C0">#BatchNo#</a>
			</td>
			<td>#DateFormat(TransactionDate,CLIENT.DateFormatShow)#</td>	
			<td>#TransactionTypeName#</td>
			<td>#Description#</td>						
			<td style="padding-left:1px;padding-right:2px">#ItemDescription# (#UoMDescription#)</td>	
			<td style="padding-left:3px;padding-right:2px" align="right">#numberformat(TransactionQuantity,"__,__._")#</td>
			
			<!--- get the price from the offered prices as they are maintained --->		
			
			<cfif (SalesPriceFixed neq "" and SalesPriceVariable neq "") and (SalesPriceFixed neq "0" and SalesPriceVariable neq "0")>
									
				<cfset prcFix = salesPriceFixed>
				<cfset prcVar = salesPriceVariable>
				<cfset amt    = (prcFix+prcVar)*TransactionQuantity>		
				
			<cfelse>		
									
						
				<cfquery name="getPrice" 
					  datasource="AppsMaterials" 
					  username="#SESSION.login#" 
					  password="#SESSION.dbpw#">		  
					  SELECT  TOP 1 ItemPriceFixed, ItemPriceVariable, ItemPrice 
					  FROM    ItemVendorOffer				 
					  WHERE   ItemNo        = '#itemNo#'
					  AND     UoM           = '#transactionuom#'
					  AND     OrgUnitVendor = '#orgunitoperator#'
					  AND     Mission       = '#url.mission#'
					  AND     LocationId    = '#warehouse.locationid#'
					  AND     DateEffective <= '#transactionDate#'
					  ORDER BY DateEffective DESC	
				</cfquery>		
				
																
				<cfif getPrice.recordcount eq "0">
								
					<!--- WE REMOVE THE LOCATION --->
				
					<cfquery name="getPrice" 
						  datasource="AppsMaterials" 
						  username="#SESSION.login#" 
						  password="#SESSION.dbpw#">		  
						  SELECT  TOP 1 ItemPriceFixed, ItemPriceVariable, ItemPrice  
						  FROM    ItemVendorOffer				 
						  WHERE   ItemNo        = '#itemNo#'
						  AND     UoM           = '#transactionuom#'
						  AND     OrgUnitVendor = '#orgunitoperator#'
						  AND     Mission       = '#url.mission#'	
						  AND     DateEffective <= '#transactionDate#'					  
						  ORDER BY DateEffective DESC	
					</cfquery>		
															
								
				</cfif>
										
				<cfif getPrice.recordcount eq "1">				
									
					<cfquery name="setPrice" 
					  datasource="AppsMaterials" 
					  username="#SESSION.login#" 
					  password="#SESSION.dbpw#">	  
					      UPDATE  ItemTransactionShipping
						  
						  SET     SalesPrice         = '#getPrice.ItemPrice#',
						  		  SalesPriceFixed    = '#getPrice.ItemPriceFixed#',
								  SalesPriceVariable = '#getPrice.ItemPriceVariable#',
								  SalesAmount        = '#getPrice.ItemPrice#'*TransactionQuantity*-1,
								  SalesTax           = '0'
					      FROM    ItemTransactionShipping S, ItemTransaction T
						  WHERE   S.TransactionId = T.TransactionId						  
						  AND     T.TransactionBatchNo = '#BatchNo#'
					</cfquery>
					
					<cfset prcFix = getPrice.ItemPriceFixed>
					<cfset prcVar = getPrice.ItemPriceVariable>
					
					<cfset amt = getPrice.ItemPrice * TransactionQuantity>
					
				<cfelse>
				
					<cfset prcFix = "0">
					<cfset prcVar = "0">			
				    <cfset amt = "0">	
					
				</cfif>		
			
			</cfif>				
			
			<td style="padding-left:3px;padding-right:1px" width="70" align="right" style="padding-left:3px;">					
		
			#numberformat(prcFix,',__.__')#
		    
			<input type  = "hidden" 
				class    = "regular" 
				name     = "#BatchNo#_SalesPriceFixed" 
				id       = "#BatchNo#_SalesPriceFixed" 
				readonly
				value    = "#numberformat(prcFix,',__.__')#"
				onchange = "ColdFusion.navigate('#SESSION.root#/warehouse/application/stock/shipping/payables/create/setPrice.cfm?batchno=#batchno#&currency='+document.getElementById('currency').value+'&pricefixed='+this.value+'&pricevariable='+document.getElementById('#BatchNo#_SalesPriceVariable').value,'total_#batchno#')"
				style    = "padding-right:1px;text-align:right;width:50">
							
				
			</td>
			
			<td style="padding-left:3px;padding-right:1px" width="70" align="right" style="padding-left:3px;">					
		
			<input type  = "text" 
				class    = "regular" 
				name     = "#BatchNo#_SalesPriceVariable" 
				id       = "#BatchNo#_SalesPriceVariable" 
				value    = "#numberformat(prcVar,',__.__')#"
				onchange = "ColdFusion.navigate('#SESSION.root#/warehouse/application/stock/shipping/payables/create/setPrice.cfm?batchno=#batchno#&currency='+document.getElementById('currency').value+'&pricefixed='+document.getElementById('#BatchNo#_SalesPriceFixed').value+'&pricevariable='+this.value,'total_#batchno#')"
				style    = "padding-right:1px;text-align:right;width:50">
				
			</td>		
			
			<td align="right" 
			   width="70" 
			   style="padding-left:3px;padding-right:1px" id="total_#batchno#">
				#numberformat(amt,',__.__')#
			</td>			
							
		</tr>
		
		<cfif BillingOfficerDate neq "">
		
		<cf_getWarehouseTime warehouse="#url.warehouse#" transactiondate="#dateformat(BillingOfficerDate,CLIENT.DateFormatShow)#"  transactiontime="#timeformat(BillingOfficerDate,'HH:MM')#">
		
		<tr><td></td><td colspan="8" style="padding-left:10px"><font size="1" color="808080">Submitted by:</font> #BillingOfficerFirstName# #BillingOfficerLastName# #dateformat(localtime,CLIENT.DateFormatShow)# #timeformat(localtime,"HH:MM")#</td></tr>
				
		</cfif>
		
		<cfset tot = amt + tot>
		
		</cfoutput>	
		
		
		<tr><td colspan="10" class="linedotted"></td></tr>
		
		<tr>
			 <td></td>
			 <td height="20" colspan="8" align="right" style="padding-top:4px" class="labelit">Amount Payable:</td>
			 <td align="right" id="totalinvoice" style="font-weight:bold;padding-top:3px;padding-right:1px" class="labelmedium">#numberformat(tot,',__.__')#</td>			 
		</tr>		
		
		<cfif access eq "GRANTED">
		
			<cfif getPending.recordcount gt "0" and ResultSet.recordcount neq "0"> 
			
			    <cfif orgunitoperator eq "">
				
					<tr><td colspan="10" class="linedotted"></td></tr>
					<tr><td colspan="10" align="center" style="padding:3px" class="labelmedium"><font color="FF0000">
						<cf_tl id="Operator not defined">.
					</td>
					</tr>
								
				<cfelse>
			
					<tr><td colspan="10" class="linedotted"></td></tr>
					<tr><td colspan="10" align="center" style="padding:3px">
					
					<input
					    type        = "button" 
						mode        = "silver"
						value       = "Generate Payable" 			
						onClick     = "payablecreate('#url.mission#','#url.warehouse#','#orgunitoperator#',purchasenoselect.value,'',document.getElementById('currency').value)"					
						id          = "Payable"		
						class       = "button10s"
						style       = "width:220px;height:25px;font-size:12px">   
						   
						</td>
					</tr>
				
				</cfif>
				
			</cfif>
		
		</cfif>
		
		<tr><td colspan="10" class="linedotted"></td></tr>		  		
		
	</cfoutput>	

</table>

