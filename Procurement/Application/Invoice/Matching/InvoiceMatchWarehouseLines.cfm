<!--
    Copyright © 2025 Promisan B.V.

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
<!--- in this mode we have an invoice created for internal issuances, which we
				   call the fuel provider mode in which an payable is generated for in the ystem
				   recorded issuances (mode external) 
				   
  In this mode the invoice will be associated and paid from a single purcahse --->
				   
<cfquery name="getPending" 
	  datasource="AppsMaterials" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">	  
	  
	  SELECT     T.Mission, 
	             T.Warehouse, 
				 WL.Location,				
				 WL.Description, 
				 B.TransactionType, 
				 T.TransactionBatchNo,
				 B.TransactionDate, 
				 T.ItemNo, 
				 T.ItemDescription, 				 
				 S.SalesPriceFixed,
				 S.SalesPriceVariable,
				 S.SalesPrice,
				 SUM(TransactionQuantity) as TransactionQuantity,
				 SUM(SalesTotal) as SalesAmount				 
				 
		FROM     ItemTransaction T 
		         INNER JOIN ItemTransactionShipping S ON T.TransactionId = S.TransactionId
		         INNER JOIN WarehouseLocation WL ON T.Warehouse = WL.Warehouse AND T.Location = WL.Location 
				 INNER JOIN WarehouseBatch B ON B.BatchNo = T.TransactionBatchNo 
								 
        WHERE    S.InvoiceId   = '#URL.ID#'	
		<!---				
		AND      T.BillingMode = 'External'	--->
		
		GROUP BY T.Mission, 
	             T.Warehouse, 
				 WL.Location,				
				 WL.Description, 
				 B.TransactionType, 
				 T.TransactionBatchNo,
				 B.TransactionDate, 
				 T.ItemNo, 
				 T.ItemDescription, 				 
				 S.SalesPriceFixed,
				 S.SalesPriceVariable,
				 S.SalesPrice	
																		
		ORDER BY T.TransactionBatchNo	
							
</cfquery>		

<cfquery name="Ledger" 
    datasource="AppsPurchase" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
		SELECT   * 
		FROM     Accounting.dbo.TransactionHeader 
		WHERE    ReferenceId = '#URL.ID#'					
</cfquery>	

<!--- determine the price --->

<table width="98%" align="center" style="border:0px dotted silver;">

	<tr><td height="5"></td></tr>
	
	<tr class="labelit">
      <td height="19"></td>
	  <td style="padding-left:3px">Date</td>   
	  <td style="padding-left:3px">Batch No</td>
	  <td>Location</td>	
	  <td>Product</td>   
	  <td align="right">Qty</td>	
	  <td align="right">Fix.</td>
	  <td align="right">Var.</td> 
	  <td align="right">Price</td>
	  <td align="right" style="padding-right:9px">Total</td>		
	  <td width="30" id="warehouseprocess"></td>  
	 </tr>
	 
	<cfset tot = "0">

	<cfoutput query="getPending">
	
		<tr class="linedotted">
		
			<td height="18" width="30" align="center" class="labelsmall">#currentrow#.</td>
			<td style="padding-left:3px;padding-right:3px">#dateformat(TransactionDate,CLIENT.DateFormatShow)#</td>
			<td style="padding-left:3px;padding-right:3px"><a href="javascript:batch('#TransactionBatchNo#','#mission#','process','','')"><font color="0080C0">#TransactionBatchNo#</font></td>
			

			<!--- not a good idea deprecated 
				
			<cfif transactiontype eq "2" and AssetId neq "">
						
				<td>
				
				<!--- asset issue --->				
							
				<cfquery name="get" 
					  datasource="AppsMaterials" 
					  username="#SESSION.login#" 
					  password="#SESSION.dbpw#">		  
					  SELECT * 
					  FROM   AssetItem
					  WHERE  AssetId = '#assetid#'		  
				</cfquery>		
	
				<a href="javascript:AssetDialog('#assetid#')" tabindex="999">									
				<font color="0080C0">#get.Model# #get.Description#</font>
				</a>					
				
				</td>			
			
			<cfelseif transactiontype eq "8">			
			
			    <!--- transfer --->
							
				<cfquery name="get" 
					  datasource="AppsMaterials" 
					  username="#SESSION.login#" 
					  password="#SESSION.dbpw#">		  
					  SELECT * 
					  FROM   Warehouse
					  WHERE  Warehouse = (SELECT Warehouse
					                      FROM   ItemTransaction 
										  WHERE  ParentTransactionId = '#transactionid#')		  
				</cfquery>														
			
			    <td>#get.WarehouseName#</td>
			
			<cfelse>
			
				<td></td>
				
			</cfif>
				
			--->
			
			<td style="padding-left:1px;padding-right:2px">#Description#</td>					
			<td style="padding-left:1px;padding-right:2px">#ItemDescription#</td>	
			<td style="padding-left:3px;padding-right:2px" align="right">#numberformat(-TransactionQuantity,"__,__._")#</td>
			<td style="padding-left:3px;padding-right:1px" width="70" align="right" style="padding-left:3px;">
			<font size="1">#numberformat(SalesPriceFixed,',__.__')#</font>
			</td>
			<td style="padding-left:3px;padding-right:1px" width="70" align="right" style="padding-left:3px;">
			<font size="1">#numberformat(SalesPriceVariable,',__.__')#</font>
			</td>
			<td style="padding-left:3px;padding-right:1px" width="70" align="right" style="padding-left:3px;">
				#numberformat(SalesPrice,',__.__')#
				<!---
				<cfif invoice.actionstatus eq "0" and ledger.recordcount eq "0">
				    <input type="text" name="price_#transactionid#" id="price_#transactionid#" style="text-align:right" 
						onchange="ColdFusion.navigate('InvoiceMatchWarehouseEdit.cfm?invoiceid=#url.id#&transactionid=#transactionid#&price='+this.value,'warehouseprocess')"
						style="width:70" class="regular" value="#numberformat(SalesPrice,',__.__')#">
				<cfelse>
					#numberformat(SalesPrice,',__.__')#
				</cfif>
				--->				
			</td>						
			<td align="right" width="70" style="padding-left:3px;padding-right:1px;padding-right:9px">
			#numberformat(SalesAmount,',__.__')#
			</td>	
			<td style="padding-top:3px">
			
			<cfif recordcount gte "2">
							
				<cfif invoice.actionstatus eq "0" and ledger.recordcount eq "0">
					<cf_img icon="delete" onclick="ptoken.navigate('InvoiceMatchWarehousePurge.cfm?invoiceid=#url.id#&batchno=#transactionbatchno#','warehouseprocess')">
				</cfif>
			
			</cfif>
			
			</td>  									
		</tr>
		
		<cfset tot = SalesAmount + tot>
		
	</cfoutput>
	
</table>

