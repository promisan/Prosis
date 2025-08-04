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

<!--- we show the stock that matches the workorder FP or stock directly associated to the FP item --->

		
<cfquery name="Get" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
  	SELECT  * 
	FROM    WorkOrderLineResource I, WorkOrder W
	WHERE   I.WorkOrderId  = W.WorkOrderId
	AND     ResourceId     = '#url.ResourceId#'	
</cfquery> 
							
<cfquery name="Line" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     WorkOrderLine WL LEFT OUTER JOIN
                   Ref_ServiceItemDomainClass R ON WL.ServiceDomain = R.ServiceDomain AND WL.ServiceDomainClass = R.Code
	WHERE    WL.WorkOrderId   = '#get.workorderid#' 
	AND      WL.WorkOrderLine = '#get.workorderline#'
</cfquery>	

<cfparam name="url.missing" default="0">
<cfset collect = url.missing>			
	
<cfquery name="getItem" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
  	SELECT  * 
	FROM    Item
	WHERE   ItemNo = '#get.ResourceItemNo#'	
</cfquery>   

<cfinvoke component = "Service.Process.WorkOrder.WorkorderLineItem"  
   method           = "InternalWorkOrder" 
   mission          = "#get.Mission#" 
   workorderid      = "#get.WorkOrderId#"
   workorderline    = "#get.WorkOrderLine#"
   Table            = "WorkOrderLineResource"
   PointerSale      = "#url.pointersale#" 
   mode             = "view"
   returnvariable   = "NotEarmarked">	
				
<!--- based on the class of the item we show transactions or aggregrated totals --->		


	<!--- get all items aggregated that have relevant stock for the requirement --->
									
	<cfquery name="stock" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
		<!--- confirmed stock --->
		
		<cfloop index="sel" list="earmarked,notearmarked">
				
	    SELECT     <cfif sel eq "earmarked">
		           'Earmarked' 
				   <cfelse>
				   'NotEarmarked'
				   </cfif> as StockMode,		
				   T.ItemNo,	          
				   I.ItemDescription,
				   C.StockControlMode,
				   I.Classification,
				   I.ItemPrecision,
				   T.TransactionUoM,
				   U.UoMDescription,	
				   U.ItemUoMId,			
				   T.Location, 
		           WL.Description AS LocationName, 
				   T.TransactionLot, 					   
				   T.WorkOrderId,
				   (SELECT Reference FROM WorkOrder WHERE WorkOrderId = T.WorkOrderId) as WorkOrderReference,			   
				   T.WorkOrderLine,
				   T.RequirementId,
				   ISNULL(SUM(T.TransactionQuantity), 0) AS Quantity, 
				   PL.TransactionLotDate, 				  
				   PL.OrgUnitVendor,
				   PL.TransactionLotSerialNo,

				   (SELECT OrgUnitName 
				    FROM Organization.dbo.Organization 
					WHERE OrgUnit = PL.OrgUnitVendor) as OrgUnitName
				   
	    FROM       Materials.dbo.ItemTransaction T INNER JOIN
	               Materials.dbo.WarehouseLocation WL ON T.Warehouse = WL.Warehouse AND T.Location = WL.Location INNER JOIN
	               Materials.dbo.ProductionLot PL     ON T.Mission   = PL.Mission AND T.TransactionLot = PL.TransactionLot INNER JOIN
		           Materials.dbo.Item I               ON I.ItemNo    = T.ItemNo INNER JOIN
				   Materials.dbo.Ref_Category C       ON C.Category  = I.Category INNER JOIN
	               Materials.dbo.ItemUoM U            ON T.ItemNo    = U.ItemNo AND T.TransactionUoM = U.UoM
				   
	    WHERE      T.Mission        = '#get.mission#' 
		AND        T.Warehouse      = '#url.warehouse#'		
				
		<cfif sel eq "earmarked">
		
		<!--- stock also associated to THIS workorder resource it which COULD BE 
		              of different items --->
					  
		AND        T.WorkOrderId    = '#get.WorkOrderId#'
		AND        T.WorkOrderLine  = '#get.WorkOrderLine#'		
		AND        T.RequirementId  = '#url.resourceid#' 
		
		<cfelse>
		
			<!--- Hanno : 28/11/2013 we select any items with the same parent 
			    for the same UoM to widen the allocation --->
			
			<cfif line.PointerStock eq "1">		
					
			AND         T.ItemNo IN (
			                         SELECT ItemNo 
					                 FROM   Materials.dbo.Item 
									 WHERE  (ParentItemNo	= '#getItem.ParentItemNo#' or ItemNo =  '#get.ResourceItemNo#')
									) 									 
			<cfelse>					
			
			<!--- this mode was enabled because we added an option to auto consume, however if we receive
			items different from the planned item it is not really possible to detemrine what should be consumed
			from which item, hereto we prevent the change of item in case of auto consumption --->
			
			AND         T.ItemNo         =  '#get.ResourceItemNo#'		
						
			</cfif>				
			
			AND         T.TransactionUoM = '#get.ResourceUoM#'
									
			<!--- NOT EARMARKED --->
			
			<cfif Line.PointerOverDraw eq "0">
			
			AND        (T.RequirementId is NULL OR T.RequirementId IN (#preserveSingleQuotes(notEarmarked)#) ) 			
			
			<cfelse>
			
			<!--- 25/5/2016 --->
									
			AND        (T.RequirementId is NULL )
						
			</cfif>
		
		</cfif>
		
		<!--- confirmed --->
		AND    (
			     (ActionStatus   = '1' AND TransactionType NOT IN ('2','8')) 
			                       OR
			     (ActionStatus  IN ('0','1') AND TransactionType IN ('2','8'))
			   )			
		
		GROUP BY   T.ItemNo,   <!--- potentially we can have several items for the same resource --->
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
					   PL.TransactionLotSerialNo,
				   <!--- added 30/12 --->	   				  
				   T.RequirementId,	  
				       T.WorkOrderId,
					   T.WorkorderLine 
		
			   
		<cfif Line.PointerOverDraw eq "0">		   		
			HAVING 	 ABS(SUM(T.TransactionQuantity)) > 0.05 			
		</cfif>
				
		<cfif sel eq "earmarked">UNION</cfif>
		
		</cfloop>
					
		ORDER BY StockMode,
		         I.ItemDescription,
		         T.ItemNo,
				 PL.TransactionLotDate,				 
				 U.ItemUomId   				 
				   
	</cfquery>  		
		
			
			
<table width="100%" cellspacing="0" cellpadding="0">	

	<cfoutput query="stock" group="StockMode">
	
		<cfif stockmode eq "Earmarked">
		<tr>
		<td width="130" colspan="6" style="height:30;font-weight:200;padding-left:20px" class="labelit"><cf_tl id="Earmarked for this order"></td>
		</tr>
		<cfelse>
		<tr>
		<td width="130" colspan="6" style="height:30;font-weight:200;padding-left:20px" class="labelit"><cf_tl id="Unearmarked"></td>
		</tr>
		</cfif>
							
		<cfif stockmode eq "Earmarked">
		    <cfset cl = "ffffcf">						
		<cfelse>					    
			<cfset cl = "f4f4f4">
		</cfif>		
	
		<cfoutput  group="ItemNo">		  
	    		
			<cfoutput group="ItemUoMId">		
					
					<cfoutput>		
													
					<tr bgcolor="#cl#" class="navigation_row_child clsWarehouseRow">
					    
						<td width="130" colspan="1" style="padding-left:20px" class="labelit line"></td>
						
						<td width="30%" colspan="2" style="padding-left:30px" class="labelit line">
						<cfif get.ResourceItemNo neq ItemNo and get.ResourceUoM neq TransactionUoM>
						     #ItemDescription# #Classification#
						</cfif>						
						</td>
						
						<!--- pending to show the workorder from which you get it --->
												
						<td width="15%" class="ccontent labelit line">
						    <cfif workorderreference neq "">
								#WorkorderReference# (#WorkOrderLine#)
							<cfelse>
								<cf_tl id="free">
							</cfif>							
						</td>						
											
						<!--- --------------------------------------------------- --->
						
						<td width="30%" colspan="1" style="padding-left:5px" class="ccontent labelit line">
							<cfif transactionlot eq "0">
								<cf_tl id="no lot">
							<cfelse>
								#TransactionLot# [#dateformat(TransactionLotDate,client.dateformatshow)#]
							</cfif>
						</td>									
						<td width="15%" colspan="2" style="padding-left:5px" class="ccontent labelit line">#LocationName#</td>
						
						<cf_precision number="#ItemPrecision#">
						
						<cfif quantity lt "0">
							<cfset clq = "red">
						<cfelse>
							<cfset clq = "transparent">								
						</cfif>		
										
						<cfif stockmode eq "Earmarked">
						    <td colspan="2" align="right" class="labelit line" style="background-color:#clq#;padding-left:10px;padding-right:10">#numberformat(quantity,pformat)#</td>				
						<cfelse>				
						    <td colspan="2" align="right" class="labelit line" style="background-color:#clq#;padding-left:10px;padding-right:10">#numberformat(quantity,pformat)#</td>				
						</cfif>
						
						<td width="9%" align="right" class="line" style="width:100;height:30;padding-right:4px">
																		
						<cfif StockControlMode eq "Stock" and quantity gt "0">
												
							<cfif quantity gt collect>
							     <cfset qty = collect>
							<cfelse>
							     <cfset qty = quantity> 
							</cfif>
							<cfif qty eq "0" or collect lte 0>
							    <cfset qty = "">
							<cfelse>
								<cfset collect = collect-qty>	   
							</cfif>
													  
						  	<cfset id    = replace(url.ResourceId,"-","","ALL")>
							<cfset uomid = replace(ItemUoMId,"-","","ALL")>
							<cfset reqid = replace(RequirementId,"-","","ALL")>
							
							<cfif qty lt "0.001">
							
							<input type= "text" 
							    name   = "#stockmode#_#id#_#uomid#_#Location#_#TransactionLotSerialNo#_#reqid#" 
							    value  = "" 
								class  = "regularxl enterastab" 
								style  = "background-color:ffffaf;width:80px;text-align:right;border:0px;border-left:1px solid silver;border-right:1px solid silver">		
							
							<cfelse>
																													
							<input type= "text" 
							    name   = "#stockmode#_#id#_#uomid#_#Location#_#TransactionLotSerialNo#_#reqid#" 
							    value  = "#round(qty*100)/100#" 
								class  = "regularxl enterastab" 
								style  = "background-color:ffffaf;width:80px;text-align:right;border:0px;border-left:1px solid silver;border-right:1px solid silver">			
								
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
				                            (SELECT   ISNULL(SUM(TransactionQuantity*-1), 0)
				                             FROM     ItemTransaction
				                             WHERE    TransactionidOrigin = T.TransactionId) AS QuantityUsed 
								FROM       ItemTransaction T
								
								<!--- select the item --->
								
								WHERE      T.Mission        = '#get.mission#'
								AND        T.Warehouse      = '#url.warehouse#'
								AND        T.Location       = '#Location#'										
								AND        T.ItemNo         = '#ItemNo#'
								AND        T.TransactionUoM = '#TransactionUoM#' 
								AND        T.TransactionLot = '#TransactionLot#'
								
								<cfif stockmode eq "Earmarked">
								
								    <!--- technically not needed the next 2 lines --->
									AND        T.WorkOrderId    = '#get.WorkOrderId#'
									AND        T.WorkOrderLine  = '#get.WorkOrderLine#'	
									AND        T.RequirementId  = '#requirementid#'
								
								<cfelse>
															
									<cfif RequirementId eq "">
									AND        T.RequirementId IS NULL
									<cfelse>
									AND        T.RequirementId = '#requirementid#'
									</cfif>
								
								<!---
								AND        (T.RequirementId is NULL or T.RequirementId IN (#preserveSingleQuotes(notEarmarked)#))		
								--->
								
								</cfif>								
								       
								AND        T.TransactionIdOrigin IS NULL <!--- is a source transaction --->
								
								<!--- transaction was not depleted yet --->
						
								AND        TransactionQuantity > 
						              (SELECT     ISNULL(SUM(TransactionQuantity*-1), 0)
		                               FROM       ItemTransaction
		                               WHERE      TransactionidOrigin = T.TransactionId)		
												
							
							</cfquery>
						
							<cfloop query="getTransaction">
							
								<cfset val = TransactionQuantity + QuantityUsed>
								
								<cf_precision number="#ItemPrecision#">
								
								<cfif val neq "">
							
								<tr bgcolor="EAFFEA" style="height:23" class="navigation_row_child clsWarehouseRow">
									<td colspan="3"><div class="hide ccontent">#stock.LocationName# #stock.TransactionLot#</div></td>							
									<td colspan="3" class="line" style="padding-left:10">
									<table><tr><td><img src="#session.root#/images/join.gif">
									</td>
									<td  class="labelit">
									<cfif TransactionReference eq ""> <cf_tl id="untagged"> #dateformat(TransactionDate,client.dateformatshow)#<cfelse>#TransactionReference#</cfif></td>
									</tr>
									</table>
									<td align="right" class="labelit line" style="padding-right:3px">#numberformat(val,"#pformat#")#</td>							
									<td class="line" align="right" style="padding-left:10px">
									
										<cfset id = replace(transactionid,"-","","ALL")>
																				
										<cfif collect gt "1">
										
										<input type="checkbox" 
											 name="#stock.stockmode#_#id#" 
											 value="#val#" 		
											 checked
											 style="width:60px;text-align:right">
										 
										 <cfelse>
										 
										 <input type="checkbox" 
											 name="#stock.stockmode#_#id#" 
											 value="#val#" 												 
											 style="width:60px;text-align:right">
										 
										 </cfif>
										 
										 <cfset collect = collect - val>
																					
									</td>		
									<td></td>	
									<td></td>
								</tr>
								
								</cfif>
										
							</cfloop>
						
						</cfif>								
					
					</cfoutput>	
				
				</cfoutput>
											
		</cfoutput>
	
	</cfoutput>
			
</table>	

<!--- show button --->

<cfquery name="get" dbtype="query">
SELECT * FROM Stock
WHERE StockMode <> 'Earmarked'
</cfquery>

<cfif get.recordcount gte "1">

	<script>
	    try {
		document.getElementById('reserve').className = "regular"
		document.getElementById('unreserve').className = "regular"
		} catch(e) {}
	</script>

</cfif>
		
