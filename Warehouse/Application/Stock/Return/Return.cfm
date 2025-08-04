<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
<!--- Query returning detail information for selected item --->
<cfoutput>

<cfset client.stmenu = "stockresupply('s','#url.systemfunctionid#')">

<cfquery name="ConsignedReceipts" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
		SELECT    I.TransactionId,
		          I.Warehouse, 
		          I.Location, 
				  I.TransactionQuantity, 
				  I.ReceiptId, 
				  R.ReceiptQuantity,
				  R.ReceiptMultiplier, 
				  R.ReceiptWarehouse, 
				  				    
				  <!--- items returned under transactiontype = 3 --->
				  (
					  SELECT ISNULL(SUM(TransactionQuantity),0)
					  FROM   ItemTransaction
					  WHERE  Mission = '#url.mission#'
					  AND    TransactionType = '3'
					  AND    ReceiptId = I.ReceiptId
				  ) as ReturnedQuantity,				  
				  
				  I.ItemNo, 
				  I.TransactionUoM, 
				  I.TransactionLot, 
				  IT.ItemDescription, 
	              UoM.UoMCode, 
				  UoM.UoMDescription, 
				  WL.LocationClass, 
				  WL.Description, 
				  R.ReceiptNo, 
				  R.DeliveryOfficer, 
				  R.DeliveryDate, 
				  P.PurchaseNo, 
				  P.OrgUnitVendor
		FROM      ItemTransaction I INNER JOIN
                  Purchase.dbo.PurchaseLineReceipt R ON I.ReceiptId = R.ReceiptId INNER JOIN
                  Item IT ON I.ItemNo = IT.ItemNo INNER JOIN
                  ItemUoM UoM ON I.ItemNo = UoM.ItemNo AND I.TransactionUoM = UoM.UoM AND IT.ItemNo = UoM.ItemNo AND IT.ItemNo = UoM.ItemNo INNER JOIN
                  WarehouseLocation WL ON I.Warehouse = WL.Warehouse AND I.Location = WL.Location INNER JOIN
                  Purchase.dbo.PurchaseLine PL ON R.RequisitionNo = PL.RequisitionNo INNER JOIN
                  Purchase.dbo.Purchase P ON PL.PurchaseNo = P.PurchaseNo
		WHERE     I.Warehouse = '#url.warehouse#'
		AND       TransactionType = '1' <!--- receipt --->
		
		<!--- has stock for this item --->
		AND       EXISTS
                          (SELECT     'X'
                            FROM      (SELECT    ItemNo, TransactionUoM, TransactionLot
                                       FROM      ItemTransaction
                                       WHERE     Mission = '#url.mission#'
                                       GROUP BY  ItemNo, TransactionUoM, TransactionLot
                                       HAVING    SUM(TransactionQuantity) > 0) 
										   
									   AS Sub
                            WHERE      sub.ItemNo = I.ItemNo 
							AND        sub.TransactionUoM = I.TransactionUoM 
							AND        sub.TransactionLot = I.TransactionLot) 
							
		AND     R.InvoiceIdMatched IS NULL
		
		AND     TransactionQuantity > 
				  (
					  SELECT ISNULL(SUM(TransactionQuantity*-1),0)
					  FROM   ItemTransaction
					  WHERE  Mission = '#url.mission#'
					  AND    TransactionType = '3'
					  AND    ReceiptId = R.ReceiptId
				  ) 						
		ORDER BY I.Warehouse, I.ItemNo
		
</cfquery>

<form name="returnform" id="returnform">

	<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">
	
	<tr>
	<td valign="top" height="100%"> 	 
	
	<cf_LanguageInput
		TableCode       = "Ref_ModuleControl" 
		Mode            = "get"
		Name            = "FunctionName"
		Key1Value       = "#url.SystemFunctionId#"
		Key2Value       = "#url.mission#"				
		Label           = "Yes">
	
		  <table width="99%" height="100%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="silver" align="center">		  
			  
			  <!---
			  <tr><td colspan="2" height="67px">
			  	
					<table height="67px" cellpadding="0" cellspacing="0" border="0" style="overflow-x:hidden" >												
						<tr>
							<td style="z-index:5; position:absolute; top:15px; left:35px; ">
								<img src="#SESSION.root#/Images/return.png" height="50">
								
							</td>
						</tr>							
						<tr>
							<td style="z-index:3; position:absolute; top:17px; left:98px; color:45617d; font-family:calibri,trebuchet MS; font-size:25px; font-weight:bold;">
								<cfoutput>#lt_content#</cfoutput>
							</td>
						</tr>
						<tr>
							<td style="position:absolute; top:4px; left:98px; color:e9f4ff; font-family:calibri,trebuchet MS; font-size:40px; font-weight:bold; z-index:2">
								<cfoutput>#lt_content#</cfoutput>
							</td>
						</tr>							
						<tr>
							<td style="position:absolute; top:45px; left:98px; color:45617d; font-family:calibri,trebuchet MS; font-size:12px; font-weight:bold; z-index:4">
								<cf_tl id="Return stock in consignment which has not been billed yet">
							</td>
						</tr>							
					</table>
			</td>
			</tr> 
			
			--->
			
			<tr><td style="font-size:28px;height:30px;padding-left:10px" class="labelmedium">#lt_content#</td></tr>
			
			<tr><td style="padding-left:20px;padding-bottom:10px" class="labelit"><font color="808080">Show all receipts which have not been billed and which stock has not been fully returned</td></tr>
		
			<!--- disable for individual stock check work order --->
		
			<tr><td align="center" valign="top">
				
				<table width="95%" class="navigation_table" aling="center">
				
					<tr class="labelmedium linedotted">
						
							<td style="padding-left:3px"></td>
							<td style="padding-left:3px"><cf_tl id="Purchase"></td>
							<td><cf_tl id="Receipt"></td>
							<td><cf_tl id="Date"></td>
							<td><cf_tl id="Item"></td>
							<td><cf_tl id="UoM"></td>
							<td><cf_tl id="Lot"></td>										
							<td align="right"><cf_tl id="Consigned"></td>
							<td align="right"><cf_tl id="Returned"></td>
							<td align="right"><cf_tl id="Billable"></td>	
							<td align="right"><cf_tl id="Return"></td>
											
						</tr>
						
						<cfif ConsignedReceipts.recordcount eq "0">
						
						<tr>
						<td colspan="11" style="height:40px" class="labelmedium" align="center"><cf_tl id="No more records to show in this view"></td>
						</tr>
						
						</cfif>
					
					<cfloop query="ConsignedReceipts">
					
						<tr class="labelmedium navigation_row">
						
							<td style="padding-left:3px">
							     <cf_img icon="expand" toggle="Yes" onclick="ptoken.navigate('#session.root#/Warehouse/Application/Stock/Return/ReturnDetail.cfm?transactionid=#transactionid#','detail_#transactionid#')">
							</td>
							<td style="padding-left:3px"><a href="javascript:ProcPOEdit('#purchaseno#')"><font color="0080C0">#PurchaseNo#</a></td>
							<td><a href="javascript:receipt('#receiptNo#','receipt')"><font color="0080C0">#ReceiptNo#</a></td>
							<td>#dateformat(DeliveryDate,client.dateformatshow)#</td>
							<td>#ItemDescription#</td>
							<td>#UoMDescription#</td>
							<td><cfif TransactionLot eq "0">n/a<cfelse>#TransactionLot#</cfif></td>		
							<td align="right" style="padding-right:2px;border-left:1px solid gray;width:80px">#TransactionQuantity#</td>
							
							<td align="right" style="padding-right:2px;border-left:1px solid gray;width:80px;border-right:1px solid gray;width:80px" bgcolor="f4f4f4" id="returned_#transactionid#">#ReturnedQuantity*-1#</td>
							
							<td align="right" style="padding-right:2px;border-left:1px solid gray;width:80px" id="billable_#transactionid#">#ReceiptQuantity# <font size="2">(*#ReceiptMultiplier#)</font></td>						
							
							<td align="right" style="padding-right:2px;border-left:1px solid gray;width:80px;border-right:1px solid gray;width:80px" bgcolor="FFFF80" id="return_#transactionid#">0</td>																
						</tr>
						
						<tr class="xhide"><td colspan="2"></td><td colspan="7" id="history_#transactionid#">
						   <cfset url.transactionid = transactionid>
						   <cfinclude template="ReturnHistory.cfm">
						   </td>
					   </tr>
						
						<tr class="xhide"><td colspan="2"></td><td colspan="9" id="detail_#transactionid#"></td></tr>
						
					</cfloop>
				
				</table>
			
			</td></tr>
			
			<cfif ConsignedReceipts.recordcount gte "1">
					
			<tr><td align="center" style="height:40px;padding-top:5px">
				<input type    = "button" 
				   	   name    = "Submit" 
					   value   = "Submit" 
					   style   = "width:200px"
					   class   = "button10g" 
					   onclick = "Prosis.busy('yes');;ptoken.navigate('#session.root#/Warehouse/Application/Stock/Return/ReturnSubmit.cfm?systemfunctionid=#url.systemfunctionid#&mission=#url.mission#&warehouse=#url.warehouse#','process','','','POST','returnform')">
			</td>
			<td id="process"></td>
			</tr>
			
			</cfif>
		
		</table>
		
	</td></tr>
	
	</table>	

</form>
	
</cfoutput>		

<cfset ajaxonload("doHighlight")>
<script>
	Prosis.busy('no')
</script>
