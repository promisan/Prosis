
<cfparam name="url.workorderid" default="">
<cfparam name="form.workselected" default="'#url.workorderid#'">

<cfif form.workselected eq "''">

<cfelse>

	<cfquery name="workorder" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	  	SELECT TOP 1 * 
		FROM   WorkOrder W, Customer C 
		WHERE  WorkorderId IN (#preservesingleQuotes(form.workselected)#)
		AND    W.Customerid = C.CustomerId
	</cfquery>  
			
	<cfquery name="Lines" 
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">	
	
		SELECT     T.TransactionId,
		           T.Mission, 
		           T.Warehouse, 
				   W.WarehouseName,
				   T.TransactionType, 
				   T.TransactionTimeZone, 
				   T.TransactionBatchNo,
				   T.TransactionDate, 
				   T.ItemNo, 
				   T.ActionStatus,
				   I.Classification,
				   I.ItemNoExternal,
				   T.TransactionLot,
				   T.WorkOrderId,
				   M.Reference,
				   T.ItemDescription, 
				   T.ItemCategory, 
				   
				   T.TransactionQuantity*-1 as TransactionQuantity, 
				     
				   
		           T.TransactionUoM, 
				   U.UoMDescription,
				   U.ItemBarCode,
				   T.TransactionCostPrice, 
				   TS.CommodityCode,
				   TS.PriceSchedule, 
				   TS.SalesCurrency, 
				   TS.SalesPrice, 
				   TS.TaxCode, 
				   TS.TaxPercentage, 
				   TS.TaxExemption, 
				   TS.TaxIncluded, 
		           TS.SalesAmount, 
				   TS.SalesTax, 
				   TS.SalesTotal, 
				   TS.InvoiceId
		FROM       ItemTransaction T 
		           INNER JOIN ItemTransactionShipping TS ON T.TransactionId = TS.TransactionId
				   INNER JOIN Warehouse W ON T.Warehouse = W.Warehouse
				   INNER JOIN Item I ON I.ItemNo = T.ItemNo 
				   INNER JOIN ItemUoM U ON U.ItemNo = T.ItemNo AND U.UoM = T.TransactionUoM
				   INNER JOIN WorkOrder.dbo.WorkOrder M ON T.WorkorderId = M.WorkOrderId
		
		WHERE      T.Mission = '#workorder.mission#' 
		
		<!--- issuance transaction assigned to the workorder of a customer --->	
		AND        T.WorkOrderId IN (#preservesingleQuotes(form.workselected)#)
	
		<!--- finished product of a workorder --->
		AND        T.RequirementId is not NULL
		
		<!--- outgoing transaction or return transactions that not voiding --->
		AND        T.TransactionType IN ('2','3')
		
		<!--- issuance transaction is not recorded as voided --->
		
		AND        T.TransactionId NOT IN (
		                                   SELECT ParentTransactionId 
		                                   FROM   ItemTransaction IT
										   WHERE  ParentTransactionId = T.TransactionId 
										   AND    TransactionType = '3'
										   AND    TransactionId NOT IN (SELECT TransactionId 
											                            FROM   Materials.dbo.ItemTransactionShipping 
													                    WHERE  TransactionId = IT.Transactionid)
										  )								
										   
									   
		
		
		<!--- confirmed  : it shows both so you are informed as to what is pending processing 
		AND        T.ActionStatus = '1' 
		--->
		
		<!--- line is not yet billed --->
		AND        (TS.InvoiceId IS NULL OR TS.InvoiceId NOT IN (SELECT  TransactionId
								                                 FROM    Accounting.dbo.TransactionHeader
		                        						         WHERE   TransactionId = TS.InvoiceId
																 AND     RecordStatus = '1'))  <!--- added to support voided transaction --->
																 
		ORDER BY T.Warehouse, M.Reference, T.TransactionLot, TransactionDate														 
		
	</cfquery>	
						
		<table width="99%">
			
		<tr class="labelmedium2 line fixrow">
			<td width="30" align="left" style="padding-left:6px">
				<input type="Checkbox" id="selectAll" class="radiol" name="selectAll" onclick="selectAllCB(this,'.clsCheckbox')">
			</td>
			<td><cf_tl id="Code"></td>
			<td><cf_tl id="Description"></td>
			<td><cf_tl id="UoM"></td>
			<td><cf_tl id="Commodity"></td>
			<td><cf_tl id="Lot"></td>
			<td><cf_tl id="Batch"></td>
			<td><cf_tl id="Date"></td>
			<td align="right"><cf_tl id="Quantity"></td>					
			<td align="right"><cf_tl id="Price"></td>
			<td align="right"><cf_tl id="Extended"></td>
			<td align="right"><cf_tl id="Tax"></td>
			<td align="right"><cf_tl id="Payable"></td>
		</tr>
						
		<cfif lines.recordcount eq "0">
			
			<tr><td colspan="13" style="height:30px" align="center" class="labelmedium2"><font color="008000"><b>No more shipments found that are pending for billing.</td></tr>
			<tr><td colspan="13" class="line"></td></tr>
			
		<cfelse>
						
			<cfoutput query="Lines" group="Warehouse">
			
				<tr class="labelmedium2">
				<td style="height:30" colspan="12"><cf_tl id="Shipped from">:&nbsp;<b>#WarehouseName#</td>
				<td align="right">
				
				<img src="#session.root#/images/refresh.gif"
				   alt="" 
				   style="cursor:pointer"
				   border="0" 
				   onclick="Prosis.busy('yes');_cf_loadingtexthtml='';ptoken.navigate('BillingEntryDetail.cfm?systemfunctionid=#url.systemfunctionid#','mycontent','','','POST','billingform');"></td>
				
				</tr>
				
				<cfset tot = 0>
				<cfset sal = 0>
				<cfset tax = 0>
				
				<cfoutput group="WorkOrderId">
				
					<cfif len(form.workselected) gt 40>
					<tr class="labelmedium2"><td style="padding-left:4px" height="5">#Reference#</td></tr>
					</cfif>
			
					<cfoutput>
									
					<tr class="labelmedium2 navigation_row line clsWarehouseRow">
										
						<td width="45" style="padding-left:4px">
						
							<cfif actionstatus eq "0">
							      <!--- transaction is pending in the warehouse --->
							      <img src="#session.root#/images/pending.gif" style="height:13px;width:15px" alt="Pending confirmation" border="0">
							<cfelse>
								<table cellspacing="0" cellpadding="0">
									<tr>
										<td style="padding-left:1px">
										
											<input type="checkbox" 
											  onclick="_cf_loadingtexthtml='';ptoken.navigate('setTotal.cfm?workorderid=#url.workorderid#','sale','','','POST','billingform')" 											  
											  class  = "radiol clsCheckbox" 
											  name   = "selected" 
											  id     = "selected"
											  value  = "'#TransactionId#'">							
											  
										</td>
										<td style="padding-top:0px"><cf_img icon="open" onclick="recordedit('#transactionid#')"></td>				
									</tr>
								</table>
							</cfif>	
						</td>
						
						<td><cfif ItemNoExternal neq "">#ItemNoExternal#<cfelse>#ItemBarCode#</cfif></td>
						<td class="ccontent">#ItemDescription#</td>
						<td class="ccontent">#UoMDescription#</td>
						<td>#CommodityCode#</td>
						<td class="ccontent">#TransactionLot#</td>
						<td class="ccontent"><a href="javascript:batch('#transactionbatchno#','#workorder.mission#','process','#url.systemfunctionid#')">#TransactionBatchNo#</a></td>
						<td>#dateformat(TransactionDate,client.dateformatshow)#</td>
						<td align="right">#TransactionQuantity#</td>						
						<td align="right">#numberformat(SalesPrice,",.__")#</td>
						<td align="right">#numberformat(SalesAmount,",.__")#</td>
						<td align="right">#numberformat(SalesTax,",.__")#</td>
						<td align="right">#numberformat(SalesTotal,",.__")#</td>
					</tr>	
					
					<cfset tot = tot + SalesTotal>
					<cfset sal = sal + SalesAmount>
					<cfset tax = tax + SalesTax>
								
					</cfoutput>
				
				</cfoutput>
			
			</cfoutput>	
			
		</cfif>	
		
		</table>	
						
	<cfset AjaxOnLoad("doHighlight")>
	
</cfif>	

<cfset AjaxOnLoad("doTotal")>

<script>
		Prosis.busy('no');	
</script>