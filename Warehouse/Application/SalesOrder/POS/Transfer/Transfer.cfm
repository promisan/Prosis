
<cfquery name="get"
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT * 
	FROM   vwCustomerRequest 
	WHERE  TransactionId = '#url.id#'		
</cfquery>

<cfquery name="Item"
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT * 
	FROM   ItemUoM 
	WHERE  ItemNo  = '#get.ItemNo#'		
	AND    UoM     = '#get.TransactionUoM#'
</cfquery>

<cfquery name="ItemList" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
	   SELECT *,
		CASE WHEN Warehouse = '#URL.Warehouse#' THEN 0 ELSE 1 END AS Type 
			
	   FROM (
	
			SELECT 	 W.Mission AS Mission, 
			         W.WarehouseName, 					 
					 IW.*, 
					 WL.Description as LocationName,
					 I.ItemPrecision,
					 I.ValuationCode,
					 U.UoMDescription,	
					 U.UoMMultiplier,		 
					 U.ItemBarCode,		
					 
					 ( SELECT  MinReorderQuantity
					   FROM    ItemWarehouse
               	       WHERE   ItemNo    = U.ItemNo 
                	   AND     UoM       = U.UoM
	                   AND     Warehouse = IW.Warehouse) as ReorderQuantity,			
					 
					 <!--- minus earmarked --->
					 			 
					 ( SELECT ROUND(SUM(TransactionQuantity),5)
					   FROM   ItemTransaction 
					   WHERE  Warehouse       = IW.Warehouse
					   AND    Location        = IW.Location
					   AND    ItemNo          = U.ItemNo
					   AND	  TransactionUoM  = U.UoM 
					   AND    WorkOrderId is NULL) as OnHand 						
					   
			FROM     ItemWarehouseLocation IW 
					 INNER JOIN Warehouse W ON IW.Warehouse = W.Warehouse 
					 INNER JOIN WarehouseLocation WL ON IW.Warehouse = WL.Warehouse AND IW.Location = WL.Location
					 INNER JOIN ItemUoM U ON IW.ItemNo = U.ItemNo AND IW.UoM = U.UoM
					 INNER JOIN Item I ON IW.ItemNo = I.ItemNo
					 
			WHERE    W.Mission = '#Get.mission#'
			AND      IW.ItemNo = '#Get.Itemno#'
			AND      IW.UoM    = '#Get.TransactionUoM#'
			AND      IW.Operational = 1
			AND      W.Operational  = 1
			-- AND      SaleMode       = '2'			 
			
			
		) as XL
		
		WHERE OnHand >= 1
				
		ORDER BY  Type, Warehouse, PickingOrder, OnHand		
</cfquery>

<cfform id="fTransfer" onsubmit = "return false;">	
				
	<cfset whs = "">
	
	<table width="100%" height="98%">
	
	<tr>
	
	<td valign="top" style="height:90%;width:70%;padding:10px;padding-left:20px;padding-right:20px">
	
	<table width="100%">
	
		<cfoutput>
						
		<tr class="labelmedium">
			<input type="hidden" name="transactionid" id="transactionid" value="#url.id#">
			<td align="left" colspan="3" style="font-size:16px">#item.ItemBarcode# #get.ItemDescription# #get.ItemNo#</td>			
			<td align="right" style="font-size:16px">#numberformat(get.TransactionQuantity,",__")#</td>			
		</tr>

		<!--- 
		<tr class="labelmedium line">
			
			<td colspan="3" style="font-size:16px">
				<cf_tl id="Minimum Quantity">
			</td>
			<td align="right" style="font-size:16px">
				<cfif qReorder.recordcount neq 0>#qReorder.MinReorderQuantity#</cfif>		
			</td>						
		</tr>
		--->
				
		<cfset remaining  = get.TransactionQuantity>
		<cfset toTransfer = 0>
		
		<cfif whs eq "">
			
			<tr class="labelmedium line" style="height:40px">
				<td colspan="2" valign="bottom" style="font-size:20px;font-weight:200;">
					<font color="004080"><cf_tl id="Stock on hand"></font>
				</td>
				<td  align="center" class="labelit" valign="bottom">
					<cf_tl id="To transfer">
				</td>	
				<td  align="center" class="labelit" valign="bottom">
					<cf_tl id="This transaction">
				</td>	
			</tr>					
				
		</cfif>	
		
		</cfoutput>
				
		<cfoutput query="ItemList" group="Warehouse">
										
				<tr class="labelmedium">					
					<td colspan="4" style="padding-top:10px;font-size:20px;padding-left:10px"><b>#WarehouseName#</td>					
				</tr>
								
				<cfoutput group="Location">
				
					<tr class="line labelmedium">					
						<td colspan="4" style="font-size:16px;padding-left:24px">#Location# #LocationName#</td>					
					</tr>
				
				<cfoutput>			
					
					<cfset minimumQty = ReorderQuantity>	
		
					<cfif minimumQty eq "">
						<cfset minimumQty = "1">
					</cfif>
												
					<tr class="labelmedium">
						
						<td colspan="1" style="padding-left:40px" align="left">#UoMDescription# (*#UOMMultiplier#)</td>
						
						<td width="10%" align="right">#numberformat(OnHand,",.__")#</td>
						
							<cfif Warehouse eq URL.Warehouse>
							
								<cfif OnHand gt remaining>
									<cfset toTransferForSale = remaining>
								<cfelse>
									<cfset toTransferForSale = OnHand>
								</cfif>										
		
								<input type = "hidden"
							     name       = "transferquantity#ItemNo#_#Warehouse#_#Location#_#UoM#"
								 id         = "transferquantity#ItemNo#_#Warehouse#_#Location#_#UoM#"
							     value      = "0">
		
								<input type = "hidden"
							     name       = "transactionquantity#ItemNo#_#Warehouse#_#Location#_#UoM#"
								 id         = "transactionquantity#ItemNo#_#Warehouse#_#Location#_#UoM#"
							     value      = "#numberformat(toTransferForSale,',__')#">	
		
								<td width="10%" align="right">0</td>							
								
								<td width="10%" align="right">
									#numberformat(toTransferForSale,",.__")#
								</td>	
								
								<cfif remaining neq "" and toTransferForSale neq "">
									<cfset remaining = remaining - toTransferForSale>
								<cfelse>
									<cfset remaining = 0>
								</cfif>		
							
							<cfelse>
							
								<cfquery name="getTransfer" 
									datasource="AppsMaterials" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
									SELECT * 
									FROM   CustomerRequestLineTransfer 
									WHERE  Transactionid = '#get.TransactionId#' 				   			
									AND    Warehouse     = '#Warehouse#'
									AND    Location      = '#Location#'
									AND    TransactionUoM = '#UoM#'
								</cfquery>
								
								<cfif OnHand gt remaining>
									<cfset toTransferForSale = remaining>
								<cfelse>
									<cfset toTransferForSale = OnHand>
								</cfif>		
								
								<!---																
								<cfif toTransferForSale lt getTransfer.TransactionTransfer>								
								    <cfset toTransferForSale = getTransfer.TransactionTransfer>
								</cfif>								
								--->
								
								<cfif OnHand gte minimumQty>
																
									<cfloop index="counter" from="1" to="10">
			    						
			    						<cfset totalToTransfer = counter*minimumQty>
			    						
			    						<cfif totalToTransfer gte toTransferForSale>
			    							<cfset totalToTransfer = totalToTransfer>
			    							<cfbreak> 
			    						</cfif>	 
			    						
									</cfloop> 
								
								<cfelse>
																															
									<cfset totalToTransfer = toTransferForSale>
								
								</cfif>
								
								<cfif toTransferForSale eq "">
									<cfset toTransferForSale = 0>
								</cfif>									
		
								<td width="10%" align="right">
								
									<cfif OnHand lt totalToTransfer>
										<cfset trf = onhand>
									<cfelse>
										<cfset trf = totalToTransfer>	
									</cfif>
								
									<input type  = "text" style="text-align:right;border-top:0px;border-bottom:0px;background-color:ffffcf"
								     name        = "transferquantity#ItemNo#_#Warehouse#_#Location#_#UoM#"
									 id          = "transferquantity#ItemNo#_#Warehouse#_#Location#_#UoM#"
								     value       = "#numberformat(trf,',__')#"
								     size        = "8"								     
									 maxlength   = "10"
									 class       = "regularxl enterastab">
									 
								</td>								 
		
								<td width="10%" align="right">
								
									<cfif OnHand lt toTransferForSale>
										<cfset trf = onhand>
									<cfelse>
										<cfset trf = toTransferForSale>	
									</cfif>
																
									<input type  = "text" style="text-align:right;border-top:0px;border-bottom:0px;background-color:ffffcf"
								     name        = "transactionquantity#ItemNo#_#Warehouse#_#Location#_#UoM#"
									 id          = "transactionquantity#ItemNo#_#Warehouse#_#Location#_#UoM#"
								     value       = "#numberformat(trf,',__')#"
								     size        = "8"								     
									 maxlength   = "10"
									 class       = "regularxl enterastab">
									 
								</td>								
								
								<cfset remaining = remaining - trf>
																						  
							</cfif>	 
						
					</tr>
				
				</cfoutput>
				
				</cfoutput>
				
			</cfoutput>
			
			<cfoutput>
			
			
			
			
			
			</cfoutput>
		
	</table>
	
	</td>
	
	<td style="width:30%;border-left:1px solid silver" valign="top">
	
		<cfoutput>
	
			<table width="100%" height="100%" style="background-color:f4f4f4;border:1px solid silver">
		
		       <cfparam name="getTransfer.TransactionLocation" default="">
				
				<tr class="labelmedium2 line" style="background-color:e1e1e1">
				    <td colspan="3" style="height:35px;font-size:16px;padding-left:5px">
					<cf_tl id="Location to be transferred">:
					</td>
				 </tr>
				 
				 <tr>	
					<td colspan="3" valign="top">
					
					<cf_divscroll>
					
					<cfquery name="warehouse"
						datasource="AppsMaterials" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT * 
							FROM   Warehouse 
							WHERE  Warehouse = '#url.warehouse#'		
					</cfquery>
					
					<!--- show relevant locations and if location has same order, the one with most stock first --->
					
					<cfquery name="LocationList"
						datasource="AppsMaterials" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT    Warehouse, Location, Description, PickingOrder, Quantity, LastDate
							FROM      (SELECT IWL.Warehouse, IWL.Location, WL.Description, IWL.PickingOrder, WL.ListingOrder,
	                                              (SELECT    SUM(TransactionQuantity) AS Expr1
	                                               FROM      ItemTransaction AS T
	                                               WHERE     Warehouse      = WL.Warehouse 
												   AND       Location       = WL.Location 
												   AND       ItemNo         = IWL.ItemNo 
												   AND       WorkOrderid is NULL
												   AND       TransactionUoM = IWL.UoM) AS Quantity,
												  
												    (SELECT    MAX(TransactionDate) AS Expr1
	                                               FROM      ItemTransaction AS T
	                                               WHERE     Warehouse      = WL.Warehouse 
												   AND       Location       = WL.Location 
												   AND       ItemNo         = IWL.ItemNo 
												   AND       WorkOrderid is NULL
												   AND       TransactionUoM = IWL.UoM) AS LastDate 
												   				
										  FROM   ItemWarehouseLocation IWL INNER JOIN WarehouseLocation WL ON IWL.Warehouse = WL.Warehouse and IWL.Location = WL.Location
										  WHERE  ItemNo         = '#get.ItemNo#'		
										  AND    UoM            = '#get.TransactionUoM#'
										  AND    WL.Warehouse   = '#url.warehouse#'
										  AND    WL.Location   != '#warehouse.LocationReceipt#'
									   	  AND    WL.Operational = 1
									  ) as B									 	
							ORDER BY PickingOrder, LastDate DESC, Quantity DESC, ListingOrder
							
					</cfquery>
					
					<!---
					
					<cfif getTransfer.TransactionLocation neq "">
					
							<cfquery name="LocationList"
							datasource="AppsMaterials" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								SELECT * 
								FROM   WarehouseLocation WL 
								WHERE  Warehouse      = '#url.warehouse#'
								AND    Operational = 1						
								ORDER BY Listingorder
							</cfquery>
									
						  <select name="LocationTo" class="regularxl" style="border-top:0px;border-bottom:0px;background-color:D3E9F8">
						   <cfloop query="LocationList">
						   	<option value="#Location#" <cfif getTransfer.TransactionLocation eq Location>selected</cfif>>#Location# #Description#</option>
						   </cfloop>	
						   <option value="#warehouse.LocationReceipt#" <cfif getTransfer.TransactionLocation eq warehouse.LocationReceipt>selected</cfif>>#warehouse.warehousename#<cf_tl id="Receipt location"></option>				   
					   </select>
					
					<cfelseif locationList.recordcount gte "1">
									
					   <select name="LocationTo" class="regularxl" style="border-top:0px;border-bottom:0px;background-color:D3E9F8">
						   <cfloop query="LocationList">
						   	<option value="#Location#">#Location# #Description#</option>
						   </cfloop>	
						   <option value="#warehouse.LocationReceipt#">#warehouse.warehousename#<cf_tl id="Receipt location"></option>				   
					   </select>				   
					   
					<cfelse>		
					
						<cfquery name="LocationList"
						datasource="AppsMaterials" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT * 
							FROM   WarehouseLocation WL 
							WHERE  Warehouse      = '#url.warehouse#'
							AND    Operational = 1						
							ORDER BY Listingorder
						</cfquery>
						
						<select name="LocationTo" class="regularxl" style="border:0px;background-color:D3E9F8">
						   <cfloop query="LocationList">
						   	   <option value="#Location#" <cfif location eq warehouse.LocationReceipt>selected</cfif>>#Location# #Description#</option>
						   </cfloop>					   
					   </select>			
					   
					</cfif>	
					
					--->
					
					<table style="width:100%" class="navigation_table">
					
					    <tr class="fixrow fixlengthlist line labelmedium2">
						  <td></td>
						  <td><cf_tl id="Location"></td>
						  <td></td>
						  <td align="right" style="padding-right:4px"><cf_tl id="OnHand"></td>
						</tr>
						
						<tr class="fixlengthlist labelmedium2 linedotted" style="height:27px">
						    <td><input type="radio" name="LocationTo" class="radiol" value="#warehouse.LocationReceipt#" <cfif getTransfer.TransactionLocation eq warehouse.LocationReceipt>checked</cfif>></td>
							<td style="padding-top:2px">Receipt location</td>
							<td></td>
							<td align="right" style="padding-right:4px"></td>
						</tr>
										
						<cfloop query="LocationList">
						<tr class="fixlengthlist labelmedium2 linedotted navigation_row" style="height:27px">
						    <td>
							<cfif getTransfer.TransactionLocation neq "">
							<input type="radio" name="LocationTo" value="#location#" class="radiol" <cfif getTransfer.TransactionLocation eq warehouse.LocationReceipt>checked</cfif>>
							<cfelse>
							<input type="radio" name="LocationTo" value="#location#" class="radiol" <cfif currentrow eq "1">checked</cfif>>
							</cfif>
							</td>
							<td style="padding-top:2px">#Description#</td>
							<td style="padding-top:2px">#dateformat(lastdate,client.dateformatshow)#</td>
							<td align="right" style="padding-right:4px;padding-top:2px">#quantity#</td>
						</tr>
						</cfloop>
					
					</table>	
					
					</cf_divscroll>						
					
					</td>
				   
				</tr>
		
		</table>
	
	    </cfoutput>	
	
	</td>
	
	</tr>
	
	<cfoutput>
	
	        <tr>
				<td colspan="4" align="center" style="padding-top:10px">
					<cf_tl id="Issue stock transfer request" var="1">
					<input type="button" value="#lt_text#" class="button10g" style="height:35px;width:470px;font-size:17px" onClick="javascript:doTransferStock('#URL.Warehouse#')">	
				</td>
			</tr>
			
			<tr style="padding-top:5px;" class="labelmedium">
				<td colspan="4" align="center">
					<cf_tl id="Request will be sent as soon as sale is settled">			
				</td>
			</tr>
			
 	</cfoutput>
	
	</table>
	
</cfform>

<cfset ajaxonload("doHighlight")>	