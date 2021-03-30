
<!--- we show the stock that matches the workorder FP or stock directly associated to the FP item --->
		
<cfquery name="Get" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  	SELECT  I.*, WL.*, W.*
		FROM    WorkOrderLineItem I, 
		        WorkOrderLine WL,
		        WorkOrder W
		WHERE   I.WorkOrderId    = W.WorkOrderId
		AND     WL.WorkOrderId   = I.WorkorderId
		AND     WL.WorkOrderLine = I.WorkOrderLine
		AND     I.WorkorderItemId = '#url.workorderItemId#'	
</cfquery>  

<cfquery name="Class" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
  	SELECT   * 
	FROM     Ref_ServiceItemDomainClass 
	WHERE    ServiceDomain  = '#get.ServiceDomain#'
	AND      Code           = '#get.ServiceDomainClass#'	
</cfquery>  
		
<!--- based on the class of the item we show transactions or aggregrated totals --->		
							
<cfquery name="stock" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
	
	
		    SELECT     T.ItemNo,	          
					   I.ItemDescription,
					   C.StockControlMode,
					   I.Classification,
					   T.TransactionUoM,
					   U.UoMDescription,	
					   U.ItemUoMId,			
					   T.Location, 
					   I.ItemPrecision,
			           WL.Description AS LocationName, 
					   T.TransactionLot, 
					   
					   <cfif Class.PointerOverdraw eq "0">	
					  					   					   
					      ISNULL(SUM(T.TransactionQuantity), 0) AS Earmarked, 
					   
					   <cfelse>
					   					   	 
			             (SELECT     ISNULL(SUM(TransactionQuantity),0)
			               FROM      Materials.dbo.ItemTransaction D
						   WHERE     D.Mission         = '#get.mission#'  	
						   AND       D.Warehouse       = '#url.warehouse#' 
						   AND       D.ItemNo          = T.ItemNo
						   AND       D.TransactionUoM  = T.TransactionUoM  
						   AND       D.Location        = T.Location
						   AND       D.TransactionLot  = T.TransactionLot
			               AND       D.RequirementId   = '#url.WorkOrderItemId#') AS Earmarked,   				
					   
					   </cfif>					   
					   
					   PL.TransactionLotDate, 
					   PL.TransactionLotSerialNo,
					   PL.OrgUnitVendor,
					   (SELECT OrgUnitName FROM Organization.dbo.Organization WHERE OrgUnit = PL.OrgUnitVendor) as OrgUnitName
					   
		    FROM       Materials.dbo.ItemTransaction T INNER JOIN
		               Materials.dbo.WarehouseLocation WL ON T.Warehouse = WL.Warehouse AND T.Location = WL.Location         INNER JOIN
		               Materials.dbo.ProductionLot PL     ON T.Mission = PL.Mission AND T.TransactionLot = PL.TransactionLot INNER JOIN
			           Materials.dbo.Item I               ON I.ItemNo = T.ItemNo     INNER JOIN
					   Materials.dbo.Ref_Category C       ON C.Category = I.Category INNER JOIN
		               Materials.dbo.ItemUoM U            ON T.ItemNo = U.ItemNo AND T.TransactionUoM = U.UoM
					   
		    WHERE      T.Mission        = '#get.mission#' 
			AND        T.Warehouse      = '#url.warehouse#'		
			
			<!--- disabled this filtering 6/6/2014
			AND        T.TransactionType != '3' <!--- returned items do not count as available --->
			--->
					
			
			<cfif class.PointerOverdraw eq "0">	
				<!--- only earmarked lines can be taken here --->		
				AND        T.RequirementId = '#url.WorkOrderItemId#' 
			<cfelse>		
				
				<!--- any location/lot which has been used for shipment in this warehouse before --->
				AND        (
				
							T.RequirementId = '#url.WorkOrderItemId#'  OR 

						   ( T.ItemNo = '#Get.ItemNo#' AND  T.TransactionUoM = '#Get.UoM#' AND T.TransactionType = '2' )
						   
						   )
				            	
			</cfif>
			
			GROUP BY   T.ItemNo,
						   I.ItemDescription,
						   I.Classification,
						   I.ItemPrecision,
						   C.StockControlMode,
					   T.TransactionUoM,
						   U.UoMDescription,
						   U.ItemUoMId,
					   T.Location, 		
					   	   WL.Description, 		  
			           T.TransactionLot, 				   
						   PL.TransactionLotDate, 
						   PL.OrgUnitVendor,
						   PL.TransactionLotSerialNo  
			
			<cfif class.PointerOverdraw eq "0">		   
			HAVING 	 SUM(T.TransactionQuantity) > 0 	
			</cfif>
		
			ORDER BY I.ItemDescription,
	        		 T.ItemNo,
					 U.ItemUomId  					 		   
					
</cfquery> 



<!--- 8/4/2016 additional provision for overdraw but only 
if this item is carried by the warehouse select WarehouseItem --->
	
<!-- only show if there is a stock value to be shown for the item --->	
		
<cfif stock.Earmarked neq "">
			
	<table width="100%" bgcolor="f4f4f4" cellspacing="0" cellpadding="0">	
		
		<cfoutput query="stock" group="ItemNo">
		
		    <cfif get.ItemNo neq ItemNo and get.UoM neq TransactionUoM>
		
			<tr bgcolor="FDF4D9">
					<td colspan="1"></td>
					<td></td>
					<td width="50%" colspan="6" style="padding-left:5px" class="labelit line">#ItemDescription# #Classification#</td>				
			</tr>
			
			</cfif>
		
			<cfoutput group="ItemUoMId">		
			
				<cf_precision number="#ItemPrecision#">
					
				<cfoutput>				
															
				<tr class="navigation_row_child clsWarehouseRow line">
					<td colspan="1"></td>
					<td></td>
					<td width="40%" colspan="1" style="padding-left:5px" class="labelit"></td>
					<td width="20%" colspan="2" style="padding-left:5px" class="ccontent labelit">#LocationName#</td>
					<td width="32%" colspan="1" style="padding-left:5px" class="ccontent labelit">
						<cfif transactionlot eq "0">
							<cf_tl id="no lot">
						<cfelse>
							#TransactionLot# [#dateformat(TransactionLotDate,client.dateformatshow)#]
						</cfif>
					</td>									
					<td width="9%" class="labelit" align="right" style="padding-right:10px">					
					#numberformat(earmarked,pformat)#									
					</td>
					<td width="9%" align="right" style="height:20;padding-right:3px">
					
					
					<cfif StockControlMode eq "Stock">
					  
					  	<cfset id = replace(ItemUoMId,"-","","ALL")>
						
						<cfif class.PointerOverdraw eq "0">
												
							<input type  = "text" 
							    name     = "ship_#id#_#location#_#TransactionlotSerialNo#" 
								id       = "ship_#id#_#location#_#TransactionlotSerialNo#"
							    value    = "" 
								onchange = "_cf_loadingtexthtml='';ptoken.navigate('setTotal.cfm?mode=stock&workorderid=#get.workorderid#&warehouse=#url.warehouse#','totals','','','POST','shipmentform')"
								class    = "regularxl enterastab" 
								style    = "height:20px;border:0px;border-left:1px solid silver;border-right:1px solid silver;width:60px;text-align:right">
							
						<cfelse>
												
							<input type  = "text" 
							    name     = "ship_#id#_#location#_#TransactionlotSerialNo#" 
								id       = "ship_#id#_#location#_#TransactionlotSerialNo#"
							    value    = "" 
								onchange = "_cf_loadingtexthtml='';ptoken.navigate('setTotal.cfm?mode=overdraw&workorderid=#get.workorderid#&warehouse=#url.warehouse#','totals','','','POST','shipmentform')"
								class    = "regularh enterastab" 
								style    = "height:20px;width:60px;text-align:right">
												
						</cfif>	
							
					</cfif> 		
							
					</td>			
				</tr>
				
				<!--- if condition is met we now show allow to show the total split into receipt transactions and other hereto
				we detect any individual transactions that are certainly not depleted 
				and the remaining you can just enter --->
				
					<cfif StockControlMode eq "Individual">
					
						<!--- Hanno 18/11/2013 attention the below query could well not be the same as the above query for its total, 
						this has to be carefully analyses and then tuned the query to prevent it --->
					
						<cfquery name="getTransaction" 
						datasource="AppsMaterials" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT    TransactionId, 
							          ItemNo, 
									  ItemDescription, 
									  ItemPrecision,
									  TransactionDate, 
									  TransactionReference, 
									  TransactionQuantity,
			                            (SELECT   ISNULL(SUM(TransactionQuantity), 0)
			                             FROM     ItemTransaction
			                             WHERE    TransactionidOrigin = T.TransactionId) AS QuantityUsed
							FROM       ItemTransaction T
							WHERE      T.Mission        = '#get.mission#'
							AND        T.Warehouse      = '#url.warehouse#'
							AND        T.Location       = '#Location#'										
							AND        T.ItemNo         = '#ItemNo#'
							AND        T.TransactionUoM = '#TransactionUoM#' 
							AND        T.TransactionLot = '#TransactionLot#'
							AND        T.RequirementId  = '#url.WorkOrderItemId#' <!--- earmarked --->
							AND        T.TransactionIdOrigin IS NULL <!--- is a source transaction --->
							
							<!--- disabled 6/6/2014 Hanno
							AND        T.TransactionType != '3' <!--- 26/3/2014 : returned items do not count as available --->
							--->
							
							GROUP BY  TransactionId, 
							          ItemNo, 
									  ItemDescription, 
									  ItemPrecision,
									  TransactionDate, 
									  TransactionReference, 
									  TransactionQuantity
							
							<!--- transaction was not depleted yet --->
							
							HAVING    TransactionQuantity +
			                              (SELECT     ISNULL(SUM(TransactionQuantity), 0)
			                               FROM       ItemTransaction
			                               WHERE      TransactionidOrigin = T.TransactionId) > 0
						
						</cfquery>
													
						<cfloop query="getTransaction">						
						
							<cfset val = TransactionQuantity + QuantityUsed>
													
							<cfif val neq "">
						
							<tr bgcolor="f5f5f5" class="navigation_row_child clsWarehouseRow line">
								<td bgcolor="efefef" colspan="4">
								<div class="hide ccontent">#stock.LocationName# #stock.TransactionLot#</div>
								</td>							
								<td width="9%" class="labelit" align="right" style="padding-right:10">#TransactionReference#</td>
								<td width="9%" align="right" class="labelit" style="padding-right:3px">#numberformat(val,"#pformat#")#</td>							
								<td width="9%" align="right">
																								
									<cfset id = replace(transactionid,"-","","ALL")>
																																										
									<input type="checkbox" 
									 name="ship_#id#" 
									 value="#numberformat(val,pformat)#" 		
									 onclick="_cf_loadingtexthtml='';ptoken.navigate('setTotal.cfm?mode=individual&workorderid=#get.workorderid#&warehouse=#url.warehouse#','totals','','','POST','shipmentform')"						
									 style="width:60px;text-align:right">								  
								 										
								</td>		
								<td></td>	
							</tr>
							
							</cfif>
									
						</cfloop>
					
					</cfif>			
				
				</cfoutput>
												
			</cfoutput>
		
		</cfoutput>
		
		<tr><td class="line" colspan="8"></td></tr>
				
	</table>			

</cfif>