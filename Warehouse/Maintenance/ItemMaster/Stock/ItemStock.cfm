

<cfparam name="url.warehouse" default="">
<cfparam name="url.mission"   default="">
<cfparam name="url.itemNo"    default="">
<cfparam name="url.UoM"       default="">

<cfoutput>
	
	<table height="100%" class="formpadding">	
	
		<cfquery name="Item"
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT   *
			FROM     Item
			WHERE    ItemNo  = '#url.itemNo#'				
		</cfquery>		
		
		<cf_precision number="#Item.ItemPrecision#">	
	
		<cfquery name="UoMList"
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT   *
			FROM     ItemUoM
			WHERE    ItemNo  = '#url.itemNo#'
			<cfif url.uom neq "">
			AND      UoM = '#url.uom#'
			<cfelse>
			AND      UoM IN (SELECT DISTINCT TransactionUoM 
			                 FROM   ItemTransaction
							 WHERE  Mission = '#url.mission#' 
					  	     AND    ItemNo  = '#url.itemNo#')				
			</cfif>				 
							 
		</cfquery>		
		
		<cfquery name="WarehouseList"
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   *
			FROM     Warehouse
			WHERE    Warehouse IN (SELECT DISTINCT Warehouse
								   FROM   ItemTransaction
								   WHERE  Mission = '#url.mission#' 
								   AND    ItemNo  = '#url.itemNo#')
			AND      Operational = 1					   
			
		</cfquery>	
		
		<tr class="labelmedium2">
		    <td style="border:1px solid silver;min-width:200px;font-size:15px;padding-left:4px"><cf_tl id="Stock"></td>
			<cfloop query="WarehouseList">
			<td align="center" style="border:1px solid silver;min-width:100px;font-size:15px;padding-top:4px">#warehouse# <font size="1"><br>#warehousename#</font></td>
			</cfloop>
			<td align="center" style="border:1px solid silver;min-width:100px;font-size:15px;padding-left:4px">#url.mission#</td>
		</tr>
		
		<cftransaction isolation="READ_UNCOMMITTED">
		
		<!--- obtain a base table to be presented in different ways in this template --->
		
		<cfquery name="StockBase"
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
		     SELECT   Warehouse, 
			          TransactionUoM, 	
					  TransactionLot,
					  ISNULL(WorkOrderId,'00000000-0000-0000-0000-000000000000') as Earmarked,
					  ActionStatus,					  
					  SUM(TransactionQuantity) as Quantity
             FROM     ItemTransaction
			 WHERE    Mission = '#url.mission#' 
	  	     AND      ItemNo  = '#url.itemNo#'		
			 <cfif url.uom neq "">
		  	 AND      TransactionUoM = '#url.uom#'		
			 </cfif>
			 GROUP BY Warehouse, 
			          TransactionUoM,
					  TransactionLot,
					  WorkOrderId,
					  ActionStatus			 						
		</cfquery>			
			
							
		<cfquery name="StockInternalRequest"
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
		   	 SELECT  Warehouse,
					 ShipToWarehouse, 
			         UoM, 						
					 RequestedQuantity - 
					 (  SELECT ISNULL(SUM(TransactionQuantity),0)
						FROM   ItemTransaction T
						WHERE  T.RequestId = V.RequestId
						AND    T.Warehouse = V.ShipToWarehouse
						AND    T.TransactionQuantity > 0) as Pending				
			 FROM    Request V
			 WHERE   Mission     = '#url.mission#' 
			 AND     ItemNo      = '#url.itemNo#'	
			 <cfif url.uom neq "">
		  	 AND     UOM = '#url.uom#'		
			 </cfif>							        	 	  
			 AND     Status IN ('2','2b')
					 <!--- AND (Status < '3' or Status = '2b' or Status = 'i') --->
			 AND     RequestType = 'Warehouse' <!--- exclude intra warehouse resupply requests : TO BE REVIEWED --->
		</cfquery>
		
		<cfquery name="StockOrder"
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
						 
				 SELECT   R.Warehouse, 	
				          R.WarehouseUoM as UoM, 
						  						  				  
						  OrderQuantity*OrderMultiplier - 
						  
						  (SELECT ISNULL(SUM(ReceiptQuantity*ReceiptMultiplier),0) 
						   FROM   Purchase.dbo.PurchaseLineReceipt PLR
						   WHERE  RequisitionNo = P.RequisitionNo
						   AND    PLR.ActionStatus != '9') as Pending
					
				FROM      Purchase.dbo.RequisitionLine R 
				          INNER JOIN Purchase.dbo.PurchaseLine P ON R.RequisitionNo   = P.RequisitionNo	
						  
				WHERE     R.Mission          = '#URL.Mission#'	
				AND       R.WarehouseItemNo  = '#url.itemNo#'	
				<cfif url.uom neq "">
			  	AND       R.WarehouseUOM = '#url.uom#'		
				</cfif>								      				
				AND       R.ActionStatus     = '3'   <!--- on purchase order --->
				AND       P.ActionStatus    != '9'  <!--- not cancelled --->
				AND       P.DeliveryStatus  != '3'  <!--- set as fully delivered, then we ignore it ---> 
					
		</cfquery>		
		
		</cftransaction>	
			
															
		<cfloop query="UoMList">
		
			<cfset unit = uom>			
			
			<tr class="labelmedium2" style="font-weight:bold">
			    <td style="border:1px solid silver;font-size:15px;padding-left:4px">#UoMDescription#</td>
				
				<cfloop query="WarehouseList">
				<td></td>
				</cfloop>
				<td></td>
			</tr>
			
			<tr class="labelmedium2" style="background-color:yellow">
		    	<td style="border:1px solid silver;font-size:15px;padding-left:4px"><cf_tl id="Technical stock"></td>			
			
			<cfloop query="WarehouseList">
			
				<cfquery name="get" dbtype="query">
					 SELECT  SUM(Quantity) as Quantity 
					 FROM    StockBase 
					 WHERE   Warehouse      = '#warehouse#' 
					 AND     TransactionUoM = '#unit#'
		  	    </cfquery>		
								
				<td align="right" style="border:1px solid silver;min-width:100px;font-size:15px;padding-right:4px">#numberformat(get.Quantity,'#pformat#')#</td>
			
			</cfloop>		
							
			<cfquery name="get" dbtype="query">
				 SELECT  SUM(Quantity) as Quantity FROM    StockBase WHERE TransactionUoM = '#unit#'
		  	</cfquery>		
								
			<td align="right" style="border:1px solid silver;min-width:100px;font-size:15px;padding-right:4px">#numberformat(get.Quantity,'#pformat#')#</td>								
			
		</tr>
		
		<!--- ----------------------------------------------------------------------------- --->
		<!--- -- earmarked stock which should no longer be used and considered as sold ---- --->
		<!--- ----------------------------------------------------------------------------- --->
		
		<tr class="labelmedium2" style="background-color:eaeaea">
		   <td style="border:1px solid silver;font-size:15px;padding-left:4px"><cf_tl id="Earmarked for shipment"></td>
		   
		   <cfloop query="WarehouseList">
			
				<cfquery name="get" dbtype="query">
					 SELECT  SUM(Quantity) as Quantity 
					 FROM    StockBase 
					 WHERE   Warehouse      = '#warehouse#' 
					 AND     TransactionUoM = '#unit#'
					 AND     Earmarked != '0'
		  	    </cfquery>		
								
				<td align="right" style="border:1px solid silver;min-width:100px;font-size:15px;padding-right:4px">#numberformat(get.Quantity,'#pformat#')#</td>
			
			</cfloop>	
											
			<cfquery name="get" dbtype="query">
				 SELECT  SUM(Quantity) as Quantity FROM StockBase WHERE TransactionUoM = '#unit#' AND Earmarked != '0'
	  	    </cfquery>		
								
			<td align="right" style="border:1px solid silver;min-width:100px;font-size:15px;padding-right:4px">#numberformat(get.Quantity,'#pformat#')#</td>						
		   
		</tr>
		
		<!--- ----------------------------------------------------------------------------- --->
		<!--- stock in warehouse that is not earmarked yet and that can be potentially used --->
		<!--- ----------------------------------------------------------------------------- --->
		
		<tr class="labelmedium2" style="background-color:80FF80">
		   <td style="border:1px solid silver;font-size:15px;padding-left:4px"><cf_tl id="Available for Usage"></td>
		   
		    <cfloop query="WarehouseList">
			
				<cfquery name="get" dbtype="query">
					 SELECT  SUM(Quantity) as Quantity 
					 FROM    StockBase 
					 WHERE   Warehouse      = '#warehouse#' 
					 AND     TransactionUoM = '#unit#'
					 AND     Earmarked = '0'
		  	    </cfquery>		
								
				<td align="right" style="border:1px solid silver;min-width:100px;font-size:15px;padding-right:4px">#numberformat(get.Quantity,'#pformat#')#</td>
				
				<cfset economic[warehouse] = get.Quantity>
			
			</cfloop>	
											
			<cfquery name="get" dbtype="query">
				   SELECT  SUM(Quantity) as Quantity FROM StockBase WHERE TransactionUoM = '#unit#' AND Earmarked = '0'
		  	</cfquery>		
								
			<td align="right" style="border:1px solid silver;min-width:100px;font-size:15px;padding-right:4px">#numberformat(get.Quantity,'#pformat#')#</td>				
			
			<cfset economic[mission] = get.Quantity>	
		   
		</tr>
								
		<!--- ---------------------------------- --->
		<!--- request issued to master warehouse --->
		<!--- ---------------------------------- --->
								
		<cfif stockInternalRequest.recordcount gte "1">	
		
			<tr class="labelmedium2" style="background-color:C4FFC4">
			   <td style="border:1px solid silver;font-size:15px;padding-left:4px"><cf_tl id="Request for replenish"></td>
			   
			   <cfloop query="WarehouseList">
			   				   		   
		   			<cfquery name="getReq" dbtype="query">			   
						  SELECT  SUM(Pending) as Pending									  
						  FROM    StockInternalRequest								  
						  WHERE   ShipToWarehouse = '#warehouse#'
						  AND     UoM             = '#unit#'															 
					</cfquery>	 
									   
		   			<td align="right" style="border:1px solid silver;min-width:100px;font-size:15px;padding-right:4px">#numberformat(getReq.Pending,'#pformat#')#</td>						   
					<cfif getReq.Pending neq "">
						<cfset economic[warehouse] = economic[warehouse] + getReq.Pending>
					</cfif>
																		
				</cfloop>	
									
				<cfquery name="get" dbtype="query">			   
					  SELECT  SUM(Pending) as Pending  FROM StockInternalRequest WHERE UoM = '#unit#'															 
				</cfquery>													
				<td align="right" style="border:1px solid silver;min-width:100px;font-size:15px;padding-right:4px">#numberformat(get.Pending,'#pformat#')#</td>	
				
				<cfif getReq.Pending neq "">
					<cfset economic[mission] = economic[mission] + getReq.Pending>	
				</cfif>
								   
			</tr>
		
			<!--- ------------------------------------------- --->
			<!--- request to be fullfilled to other warehouse --->
			<!--- ------------------------------------------- --->
			
			<tr class="labelmedium2" style="background-color:f1f1f1">
			   <td style="border:1px solid silver;font-size:15px;padding-left:4px"><cf_tl id="Internally committed"></td>
			   
			   <cfloop query="WarehouseList">				   
			       
			   			<cfquery name="get" dbtype="query">SELECT  SUM(Pending) as Pending									  
							  FROM    StockInternalRequest								  
							  WHERE   Warehouse   = '#warehouse#'
							  AND     UoM         = '#unit#'</cfquery>	 
			   
			   			<td align="right" style="border:1px solid silver;min-width:100px;font-size:15px;padding-right:4px">#numberformat(get.Pending,'#pformat#')#</td>						   
						
						<cfif getReq.Pending neq "">
							<cfset economic[warehouse] = economic[warehouse] - getReq.Pending>	
						</cfif>
													
				</cfloop>	
									
				<cfquery name="get" dbtype="query">			   
					  SELECT  SUM(Pending) as Pending									  
					  FROM    StockInternalRequest								  
					  WHERE   UoM        = '#unit#'															 
				</cfquery>	 
											
				<td align="right" style="border:1px solid silver;min-width:100px;font-size:15px;padding-right:4px">#numberformat(get.Pending,'#pformat#')#</td>		
				
				<cfif getReq.Pending neq "">
					<cfset economic[mission] = economic[mission] - getReq.Pending>	
				</cfif>
								   
			</tr>
		
		</cfif>		
				   
				   
		
		
		<!--- ---------------------------------- --->
		<!--- -------- procurement orders ------ --->
		<!--- ---------------------------------- --->
								
		<cfif stockOrder.recordcount gte "1">	
					
		<tr class="labelmedium2" style="background-color:C4FFC4">		
		   <td style="border:1px solid silver;font-size:15px;padding-left:4px"><cf_tl id="On Order"></td>
			   
			   			  		   
		   <cfloop query="WarehouseList">	
			   
			   	<cfquery name="getPO" dbtype="query">
				   SELECT  SUM(Pending) as Pending FROM StockOrder WHERE Warehouse = '#warehouse#' AND UoM = '#unit#'
			    </cfquery>
			   	
			  	<td align="right" style="border:1px solid silver;min-width:100px;font-size:15px;padding-right:4px">#numberformat(getPO.Pending,'#pformat#')#</td>	
			   				
			   <cfif getPO.Pending neq "">
							   				   
				     <cfif economic[warehouse] neq "">
				
					      <cfset economic[warehouse] = economic[warehouse] + getPO.Pending>	
						 
					 <cfelse>
						 
					     <cfset economic[warehouse] = getPO.Pending>		 
						
					 </cfif>			   
				 
				</cfif>	
					
			</cfloop>	
			    
				
			<cfquery name="getPO" dbtype="query">			   
				  SELECT  SUM(Pending) as Pending FROM StockOrder WHERE UoM = '#unit#'															 
			</cfquery>	 
			   
			<cfif getPO.Pending neq "">
				
				<cfif economic[mission] neq "">				
				
				     <cfset economic[mission] = economic[mission] + getPO.Pending>	
					
				 <cfelse>
						 
					 <cfset economic[mission] = getPO.Pending>		 
						
				 </cfif>	
			</cfif>											
			<td align="right" style="border:1px solid silver;min-width:100px;font-size:15px;padding-right:4px">#numberformat(getPO.Pending,'#pformat#')#</td>		
							   
		</tr>
		
		</cfif>
			   		
		<tr class="labelmedium2" style="background-color:BFECFB">
		   <td style="border:1px solid silver;font-size:15px;padding-left:4px"><cf_tl id="Economical">
		   
		    <cfloop query="WarehouseList">		
			
					<cfset val = evaluate(economic["#warehouse#"])>
									   			
		   			<td align="right" style="border:1px solid silver;min-width:100px;font-size:15px;padding-right:4px">#numberformat(val,'#pformat#')#</td>						   
													
			</cfloop>	
				
			<cfquery name="get" dbtype="query">			   
				  SELECT  SUM(Pending) as Pending									  
				  FROM    StockInternalRequest								  
				  WHERE   UoM        = '#unit#'															 
			</cfquery>	 
			
			<cfset val = evaluate(economic["#mission#"])>								
			<td align="right" style="border:1px solid silver;min-width:100px;font-size:15px;padding-right:4px">#numberformat(val,'#pformat#')#</td>		
				
		</tr>
		
		</cfloop>
		
	</table>	
	
</cfoutput>

