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
<cfquery name="Warehouse" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  	SELECT  * 
		FROM    Warehouse
		WHERE   Warehouse = '#url.warehouse#'
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
			   PL.TransactionLotSerialNo,
			   ISNULL(SUM(T.TransactionQuantity), 0) AS Earmarked, 
			   PL.TransactionLotDate, 
			   PL.OrgUnitVendor,
			   (SELECT OrgUnitName 
			    FROM   Organization.dbo.Organization 
				WHERE  OrgUnit = PL.OrgUnitVendor) as OrgUnitName
			   
    FROM       Materials.dbo.ItemTransaction T INNER JOIN
               Materials.dbo.WarehouseLocation WL ON T.Warehouse = WL.Warehouse AND T.Location = WL.Location         INNER JOIN
               Materials.dbo.ProductionLot PL     ON T.Mission = PL.Mission AND T.TransactionLot = PL.TransactionLot INNER JOIN
	           Materials.dbo.Item I               ON I.ItemNo = T.ItemNo     INNER JOIN
			   Materials.dbo.Ref_Category C       ON C.Category = I.Category INNER JOIN
               Materials.dbo.ItemUoM U            ON T.ItemNo = U.ItemNo AND T.TransactionUoM = U.UoM
			   
    WHERE      T.Mission         = '#warehouse.mission#' 
	AND        T.Warehouse       = '#url.warehouse#'	
	<!--- item selected --->	
	AND        T.ItemNo          = '#url.itemno#' 		
	AND        T.TransactionUoM  = '#url.uom#'
	
	<cfif url.workorderidselect eq "">
	
	AND        T.WorkOrderId   IS NULL
	AND        T.RequirementId IS NULL
	
	<cfelseif url.workorderidselect neq "All">
		
		AND        T.WorkOrderId   = '#url.workorderidselect#'	
		AND        T.RequirementId = '#url.WorkOrderItemId#' 
	
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
				   PL.TransactionLotSerialNo,
				   PL.OrgUnitVendor	
			   
	HAVING 	 SUM(T.TransactionQuantity) > 0 	
		
	ORDER BY I.ItemDescription,
	         T.ItemNo,
			 U.ItemUomId  					 		   
			   
</cfquery> 

	
<cfif stock.Earmarked neq "">
		
	<table width="100%" cellspacing="0" cellpadding="0" style="border:0px solid silver">	
						
		<!-- only show if there is a stock value to be shown for the item --->	
			
		<cfquery name="Get" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			  	SELECT  * 
				FROM    WorkOrderLineItem I, WorkOrder W
				WHERE   I.WorkOrderId   = W.WorkOrderId
				<cfif url.workorderitemid neq "">
				AND     WorkorderItemId = '#url.workorderItemId#'	
				<cfelse>
				AND     1=0
				</cfif>
		</cfquery>  
		
		<cfoutput query="stock" group="ItemNo">
		
		    <cfif get.ItemNo neq ItemNo and get.UoM neq TransactionUoM>
		
			<tr class="labelit" bgcolor="FDF4D9">
					<td colspan="1"></td>
					<td></td>
					<td width="50%" colspan="6" style="padding-left:5px" class="line">#ItemDescription# #Classification#</td>				
			</tr>
			
			</cfif>
		
			<cfoutput group="ItemUoMId">		
			
				<cf_precision number="#ItemPrecision#">
					
				<cfoutput>				
							
				<tr class="labelmediumn2 navigation_row_child clsWarehouseRow">
					<td colspan="1"></td>
					<td></td>
					<td width="3%" colspan="1" style="padding-left:5px" class="line"></td>
					<td width="33%" colspan="2" style="padding-left:5px" class="ccontent line">#LocationName#</td>
					<td width="56%" colspan="1" style="padding-left:5px" class="ccontent line">
						<cfif transactionlot eq "0">
							no lot
						<cfelse>
							#TransactionLot# #dateformat(TransactionLotDate,client.dateformatshow)#
						</cfif>
					</td>	
													
					<td width="9%" class="line" align="right" style="padding-right:10">#numberformat(earmarked,pformat)#</td>
					
					<td width="9%" align="right" class="line" style="height:20;padding-right:3px">
										
					<cfif StockControlMode eq "Stock">
					  
					  	<cfset uomid = replace(ItemUoMId,"-","","ALL")>
						<cfset itmid = replace(url.workorderitemid,"-","","ALL")>
																														
						<input type  = "text" 
						    name     = "transfer_#uomid#_#location#_#TransactionLotSerialNo#_#itmid#" 
							value    = "" 
							onchange = "_cf_loadingtexthtml='';ptoken.navigate('#SESSION.root#/WorkOrder/Application/Assembly/EarmarkStock/setTotal.cfm?warehouse=#url.warehouse#','totals','','','POST','stockform')"
							class    = "regularxl enterastab" 
							style    = "width:60px;text-align:right;border:0px;border-left:1px solid silver;border-right:1px solid silver">
							
					</cfif> 		
							
					</td>			
				</tr>
				
				<!--- if condition is met we now show allow to show the total split into receipt transactions and other hereto
				we detect any individual transactions that are certainly not depleted 
				and the remaining you can just enter --->
				
					<cfif StockControlMode eq "Individual">
					
						<!--- Dev 18/11/2013 attention the below query could well not be the same as the above query for its total,
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
							WHERE      T.Mission        = '#warehouse.mission#'
							AND        T.Warehouse      = '#url.warehouse#'
							AND        T.Location       = '#Location#'										
							AND        T.ItemNo         = '#ItemNo#'
							AND        T.TransactionUoM = '#TransactionUoM#' 
							AND        T.TransactionLot = '#TransactionLot#'
							
							<cfif url.workorderidselect eq "">
							AND        T.WorkOrderId   IS NULL
							AND        T.RequirementId IS NULL
							<cfelseif url.workorderidselect neq "All">
							AND        T.WorkOrderId   = '#url.workorderidselect#'
							AND        T.RequirementId = '#url.WorkOrderItemId#' 
							<cfelse>
							AND        T.WorkOrderId  IN (SELECT WorkorderId 
							                               FROM   Workorder.dbo.Workorder 
														   WHERE  Mission = '#url.mission#')											
							</cfif>					
							
							AND        T.TransactionIdOrigin IS NULL <!--- is a source transaction --->
							
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
						
							<tr bgcolor="f5f5f5" class="labelmedium2 navigation_row_child clsWarehouseRow">
								<td bgcolor="efefef" colspan="4">
								<div class="hide ccontent">#stock.LocationName# #stock.TransactionLot#</div>
								</td>							
								<td width="9%" class="line" align="right" style="padding-right:10">#TransactionReference#</td>
								<td width="9%" align="right" class="line" style="padding-right:3px">#numberformat(val,"#pformat#")#</td>							
								<td width="9%" align="right" class="line">
								
									<cfset id = replace(transactionid,"-","","ALL")>
																																											
									<input type     = "checkbox" 
										 name       = "transfer_#id#" 
										 value      = "#numberformat(val,pformat)#" 		
										 onclick    = "_cf_loadingtexthtml='';ptoken.navigate('#SESSION.root#/WorkOrder/Application/Assembly/EarmarkStock/setTotal.cfm?warehouse=#url.warehouse#','totals','','','POST','stockform')"						
										 style      = "width:60px;text-align:right">
								  											
								</td>		
								<td></td>	
							</tr>
							
							</cfif>
									
						</cfloop>
					
					</cfif>			
				
				</cfoutput>
												
			</cfoutput>				
		
		</cfoutput>
											
	</table>	
	
</cfif>