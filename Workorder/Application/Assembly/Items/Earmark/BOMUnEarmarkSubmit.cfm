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
<!--- processing the requests into a pickticket batch 

generate a batch for the selected warehouse
generate the lines
open the screen for the batch and refresh the underlying listing for the collected quanties

--->

<cfquery name="Workorder" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
	SELECT    *
    FROM      Workorder
    WHERE     WorkorderId = '#url.workorderid#'    									  
</cfquery>

<cfquery name="workorderline" 
	datasource="AppsWorkOrder"
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	   SELECT * 
	   FROM   WorkorderLine 
	   WHERE  WorkorderId   = '#url.workorderid#'
	   AND    WorkOrderLine = '#url.workorderline#'
</cfquery>   

<cfquery name="Parameter" 
   datasource="AppsMaterials" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   SELECT   TOP 1 *
   FROM     WarehouseBatch
   ORDER BY BatchNo DESC
</cfquery>

<cfif Parameter.recordcount eq "0">
	<cfset batchNo = 10000>
<cfelse>
	<cfset BatchNo = Parameter.BatchNo+1>
	<cfif BatchNo lt 10000>
	     <cfset BatchNo = 10000+BatchNo>
	</cfif>
</cfif>	

<!--- there are 2 modes : collect and transfer to other warehouse --->

<cfparam name="url.action" default="8">
	
<cftransaction>
	
	<!--- add a batch --->
	
	<cf_assignid>
					
	<cfquery name="Insert" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		INSERT INTO WarehouseBatch
				    (Mission,
					 Warehouse, 
					 BatchWarehouse,				
				 	 BatchNo, 	
					 BatchId,
					 BatchDescription,		
					 BatchClass,				
					 TransactionDate,
					 TransactionType, 
					 OfficerUserId, 
					 OfficerLastName, 
					 OfficerFirstName)
		VALUES ('#workorder.mission#',
		        '#url.warehouse#',
				'#url.warehouse#',			 
	    	    '#batchNo#',	
				'#rowguid#',	
				<cfif url.action eq "2">		
				'WorkOrder Collection',	
				<cfelse>
				'WorkOrder Un-Earmark',	
				</cfif>						
				'WOCollect',
				'#dateformat(now(),client.dateSQL)#',
				'#url.action#',
				'#SESSION.acc#',
				'#SESSION.last#',
				'#SESSION.first#')
	</cfquery>
	
	<!--- --------- --->
	<!--- add lines --->
	<!--- --------- --->
		
	<cfinvoke component = "Service.Process.WorkOrder.WorkorderLineItem"  
	   method           = "InternalWorkOrder" 
	   datasource       = "AppsMaterials"
	   mission          = "#WorkOrder.Mission#" 
	   workorderid      = "#url.WorkOrderId#"
       workorderline    = "#url.WorkOrderLine#"
	   Table            = "WorkOrderLineResource"
	   PointerSale      = "#url.pointersale#"
	   Mode             = "query"
	   returnvariable   = "NotEarmarked">		
		
	 <cfquery name="ResourceLines" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">		
		SELECT * 
		FROM   WorkOrder.dbo.WorkOrderLineResource
		WHERE  WorkOrderId   = '#url.workorderid#'
		AND    WorkOrderLine = '#url.workorderline#'			
	</cfquery>
	
	<cfloop query="resourcelines">		    
	   
		<cfset resid = resourceid>
	
		<cfquery name="getItem" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
		  	SELECT  * 
			FROM    Item
			WHERE   ItemNo = '#ResourceItemNo#'	
		</cfquery>   
			
	    <cfquery name="StockLines" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			
			<!--- confirmed stock --->
			
			<cfloop index="sel" list="earmarked">
			
		    SELECT     <cfif sel eq "earmarked">
			           'Earmarked' 
					   <cfelse>
					   'NotEarmarked'
					   </cfif> as StockMode,		
					   T.ItemNo,	          
					   I.ItemDescription,
					   C.StockControlMode,
					   T.ItemCategory,
					   I.Classification,				 
					   T.TransactionUoM,
					   U.UoMDescription,	
					   U.ItemUoMId,						  
					   T.Location, 		          
					   T.TransactionLot, 
					   PL.TransactionLotSerialNo,
					   T.RequirementId,
					   T.WorkOrderId,
					   T.WorkOrderLine,
					   ISNULL(SUM(T.TransactionQuantity), 0) AS OnHand
					   
		    FROM       Materials.dbo.ItemTransaction T INNER JOIN	              	              
			           Materials.dbo.Item I               ON I.ItemNo = T.ItemNo INNER JOIN
					   Materials.dbo.Ref_Category C       ON C.Category = I.Category INNER JOIN
		               Materials.dbo.ItemUoM U            ON T.ItemNo = U.ItemNo AND T.TransactionUoM = U.UoM INNER JOIN
					   Materials.dbo.ProductionLot PL     ON T.Mission   = PL.Mission AND T.TransactionLot = PL.TransactionLot 
					   
		    WHERE      T.Mission        = '#workorder.mission#' 
			AND        T.Warehouse      = '#url.warehouse#'	
						
					
			<cfif sel eq "earmarked">
			
				<!--- stock associated to this workorder --->
				AND      T.WorkOrderId    = '#url.WorkOrderId#'
				AND      T.WorkOrderLine  = '#url.WorkOrderLine#'	
				AND      T.RequirementId  = '#resourceid#'	
					
			<cfelse>
							
				<!--- Hanno : 28/11/2013 we select any items with the same parent for the same UoM to widen the allocation --->
		
				AND         T.ItemNo IN (SELECT ItemNo 
				                         FROM   Materials.dbo.Item 
								         WHERE  ParentItemNo	= '#getItem.ParentItemNo#' or ItemNo =  '#ResourceItemNo#')
			    AND      T.TransactionUoM = '#ResourceUoM#'
				AND      (T.RequirementId is NULL or T.RequirementId IN (#preserveSingleQuotes(notEarmarked)#))		
			
			</cfif>
			
			 <!--- confirmed : rethink --->
			 AND    (
				     (ActionStatus   = '1' AND TransactionType NOT IN ('2','8')) 
				                       OR
				     (ActionStatus  IN ('0','1') AND TransactionType IN ('2','8'))
				   )		
			
			<!--- confirmed transactions only adjusted 18/9/2016 
			AND    (
				     (ActionStatus   = '1' AND TransactionType != '2') 
				            OR
				     (ActionStatus  IN ('0','1') AND TransactionType = '2')
				   )				
				   
			--->	   
			
			GROUP BY   T.ItemNo,
						   I.ItemDescription,
						   I.Classification,					 
						   C.StockControlMode,
						   T.ItemCategory,
					   T.TransactionUoM,
						   U.UoMDescription,
						   U.ItemUoMId,
					   T.Location, 			  
			           T.TransactionLot,
					       PL.TransactionLotSerialNo,
					   T.RequirementId,
						   T.WorkOrderId,
						   T.WorkOrderLine 
					   
			HAVING 	 SUM(T.TransactionQuantity) > 0 				
			</cfloop>
						
			ORDER BY 
			         I.ItemDescription,
			         T.ItemNo,
					 StockMode,
					 U.ItemUomId  		
					 			    					   
					   
		</cfquery>	
		
		
		<!--- we have a consolidatedidated list of items totaled on the stock level to be processed split is earmarked and not earmarked --->
		
		<!--- define the contra account for the goods to be recorded against --->				
						
		<cfquery name="AccountProduction" 
			datasource="AppsMaterials"
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				   SELECT * 
				   FROM   Workorder.dbo.WorkorderGLedger 
				   WHERE  WorkorderId   = '#url.workorderid#'		
				   AND    Area          = 'Production'
				   AND    GLAccount IN (SELECT GLAccount 
				                        FROM   Accounting.dbo.Ref_Account)	  
		</cfquery>   		
	
			<cfloop query="StockLines">
			
				<cfif url.action eq "2">  <!--- earmarking and collection --->
			
					<cfif AccountProduction.GLAccount eq "">
					
						<!--- then we defined the default income account for the production based
						     on the category which ideally we do not want to here to be applied --->
												
						<cfquery name="AccountProduction"
								datasource="AppsMaterials" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
								    SELECT  GLAccount
									FROM    Ref_CategoryGLedger
									WHERE   Category   = '#ItemCategory#' 
									AND     Area       = 'Production'
									AND     GLAccount IN (SELECT GLAccount 
									                      FROM   Accounting.dbo.Ref_Account)
						</cfquery>	
							
					</cfif>
					
					<cfquery name="AccountTask"
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
				    	SELECT  GLAccount
						FROM    Ref_CategoryGLedger
						WHERE   Category = '#ItemCategory#' 
						AND     Area     = 'Variance'
					</cfquery>	
					
					<cfquery name="AccountStock" 
				    datasource="AppsMaterials" 
				    username="#SESSION.login#" 
				    password="#SESSION.dbpw#">
					   SELECT * 
					   FROM   Ref_CategoryGLedger 
					   WHERE  Area     = 'Stock'
					   AND    Category = '#ItemCategory#'
					</cfquery>
					
					<cfif AccountProduction.GLAccount eq "" or AccountStock.GLAccount eq "" or AccountTask.GLAccount eq "">
				   
					   <table align="center">
					    	<tr>
							   <td class="labelmedium" align="center"><font color="FF0000">Attention: GL Account for stock and/or workorder production has not been defined yet.</td>
							</tr>
					   </table>
					   <script>
					  	 Prosis.busy('no');
					   </script>
					   <cfabort>
					
					</cfif>
				
				<cfelseif url.action eq "8">  <!--- un/earmarking and consignation --->
				
					<cfquery name="AccountStock" 
				   datasource="AppsMaterials" 
				   username="#SESSION.login#" 
				   password="#SESSION.dbpw#">
					   SELECT * 
					   FROM   Ref_CategoryGLedger 
					   WHERE  Area     = 'Stock'
					   AND    Category = '#ItemCategory#'
					</cfquery>
				
					<cfquery name="AccountTask"
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
				    	SELECT  GLAccount
						FROM    Ref_CategoryGLedger
						WHERE   Category = '#ItemCategory#' 
						AND     Area     = 'Variance'
					</cfquery>	
					
					<cfif AccountTask.GLAccount eq "" or AccountStock.GLAccount eq "">
				   
					   <table align="center">
					   	<tr><td class="labelmedium" align="center"><font color="FF0000">Attention: GL Account for stock and/or stock variation has not been defined yet.<br> Please contact your administrator</td></tr>
					   </table>
	
					   <script>
						   	Prosis.busy('no');
					   </script>
					   <cfabort>
					
					</cfif>					
								
				</cfif>
								
				<cfif StockControlMode eq "stock">
									
					<cfset id     = replace(resid,"-","","ALL")>
					<cfset uomid  = replace(ItemUoMId,"-","","ALL")>
					<cfset reqid  = replace(Requirementid,"-","","ALL")>
					
					<cfparam name = "Form.#stockmode#_#id#_#uomid#_#location#_#transactionlotserialno#_#reqid#" default="0">				
					<cfset qty    = evaluate("Form.#stockmode#_#id#_#uomid#_#location#_#transactionlotserialno#_#reqid#")>
					
					<cfif Onhand gte qty>
						 <cfset apply = qty>
						 <cfset qty   = apply>
					<cfelse>
						 <cfset apply = onhand>
						 <cfset qty   = apply>	    
					</cfif>											
					
					<cfinclude template="BOMUnEarmarkSubmitTransaction.cfm">
									
				<cfelse>
												
				    <!--- determine the transactions --->
					
					<!--- -----indivdual mode------- --->
			
					<cfquery name="getTransaction" 
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT    T.TransactionId,
						          T.Mission,
						          T.Warehouse,
						          T.ItemNo,						 
						          T.TransactionUoM,						  
								  T.Location, 						           
								  T.TransactionLot, 
								  T.TransactionReference,
								  T.TransactionQuantity,
								  T.WorkOrderId,
								  T.WorkOrderLine,
								  T.RequirementId,
								  <!--- ATTENTION please note that this does include uncleared transactions --->
		                          (SELECT   ISNULL(SUM(TransactionQuantity), 0)
		                            FROM     ItemTransaction
		                            WHERE    TransactionidOrigin = T.TransactionId) AS QuantityUsed
									
						FROM       ItemTransaction T
						
						WHERE      T.Mission        = '#workorder.mission#' 
						AND        T.Warehouse      = '#url.warehouse#'		
								
						<cfif stockmode eq "Earmarked">
						
							<!--- stock associated to this workorder --->
							AND      T.WorkOrderId    = '#url.WorkOrderId#'
							AND      T.WorkOrderLine  = '#url.WorkOrderLine#'	
							AND      T.RequirementId  = '#requirementid#'	
								
						<cfelse>
						
							<!--- stock associated to workorders that are free for items in this workorder BOM --->
							AND      T.ItemNo         = '#ItemNo#'
						    AND      T.TransactionUoM = '#TransactionUoM#'
							AND      (T.RequirementId is NULL or T.RequirementId IN (#preserveSingleQuotes(notEarmarked)#))		
						
						</cfif>
												
						AND        T.TransactionIdOrigin IS NULL <!--- is a source transaction --->
						
						<!--- transaction was not depleted yet --->
						
						AND        TransactionQuantity > 
						              (SELECT     ISNULL(SUM(TransactionQuantity*-1), 0)
		                               FROM       ItemTransaction
		                               WHERE      TransactionidOrigin = T.TransactionId)		
						
					
					</cfquery>		
					
					<!--- get the quantities --->
											
					<cfloop query="getTransaction">
					
						<cfset stockmode = stocklines.stockmode>
					
						<cfset id = replace(transactionid,"-","","ALL")>	
						
						<cfparam name="Form.#stocklines.stockmode#_#id#" default="0">				
						<cfset qty = evaluate("Form.#stocklines.stockmode#_#id#")>
						
						<cfset Onhand = TransactionQuantity - QuantityUsed>
						
						<cfif Onhand gte qty>
							   <cfset apply = qty>
							   <cfset qty = apply>
						<cfelse>
							   <cfset apply = onhand>
							   <cfset qty = apply>	    
						</cfif>						
							
					    <cfset traidorigin  = Transactionid> 	
						<cfset trareference = TransactionReference> 		 										
						<cfinclude template="BOMUnEarmarkSubmitTransaction.cfm">					
						
					</cfloop>					
				
				</cfif>							
							
			</cfloop>			
			
	</cfloop>		
		
	<!--- check stock --->
	
	<cfquery name="checkBatch" 
		datasource="AppsMaterials"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			   SELECT * 
			   FROM   ItemTransaction
			   WHERE  TransactionBatchNo = '#BatchNo#'			 
	</cfquery>   		
		
	<cfif checkBatch.recordcount eq "0">
	
		<!--- delete batch --->
						
		<cfquery name="delete" 
		   datasource="AppsMaterials" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
			   DELETE FROM WarehouseBatch
			   WHERE BatchNo = '#batchno#'
		</cfquery>	
	
		<script language="JavaScript">			
			alert("Have you recorded and/or selected an item/quantity to be processed ?")			
			Prosis.busy('no');
		</script>
			
		<cfabort>
		
	</cfif>	
	
</cftransaction>
	
<!--- --------------------- --->
<!--- ---open batch form--- --->
<!--- --------------------- --->
	
<cfoutput>

	<script language="JavaScript">
	  // refresh screen	  	 
	  ptoken.navigate('#session.root#/workorder/application/Assembly/Items/Earmark/BOMStockOnHand.cfm?mode=#url.mode#&workorderid=#url.workorderid#&workorderline=#url.workorderline#&warehouse=#url.warehouse#&category=#url.category#&pointersale=#url.pointersale#','process')	 
	  Prosis.busy('no');
	  // load batch screen
	  w = #CLIENT.width# - 70;
	  h = #CLIENT.height# - 160;
	  ptoken.open("#session.root#/Warehouse/Application/Stock/Batch/BatchView.cfm?trigger=workorder&mode=process&mission=#workorder.mission#&batchno=#batchno#","batchform","left=30, top=30, width=" + w + ", height= " + h + ", toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=yes")
	</script>
	
</cfoutput>
