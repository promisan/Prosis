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

<!--- meta code : 

   loop through the sale lines that are selected and determine the requirement, 
   then check for the selected warehouse, 
   the stock on hand for item/uom per location (sort)/ lot (olderst first)
   create reserve transaction, if qty < needed, go to the next line of the stock
   otherwise next sale item. 
   open the batch   
--->   

<cfset count = 0>
    
<cfquery name="workorder" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *
	    FROM     WorkOrder
		WHERE    WorkOrderId = '#url.workorderid#'	
</cfquery>	 

<cf_tl id="Reserve stock" var="reserve">

<cfparam name="form.selectline" default="">
<cfparam name="form.batchReference" default="#reserve#">

<cfif form.selectline neq ""> 
	
<cfquery name="Sale" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
		SELECT  WOL.*,
		
				( 
				 SELECT    ISNULL(SUM(TransactionQuantity), 0) 
				 FROM      Materials.dbo.ItemTransaction
				 WHERE     Mission           = '#workorder.Mission#'		
				 AND       TransactionType != '2'
				 AND       RequirementId = WOL.WorkOrderItemId
				) as Reserved,  <!--- quantity received or quantity internally produced for this workorder --->
										
				( 
				
				 SELECT    ISNULL(SUM(TransactionQuantity*-1), 0)
				 FROM      Materials.dbo.ItemTransaction
				 WHERE     TransactionType IN ('2','3')  <!--- 10/3/2013 removed the '8' from the transaction type --->
				 AND       Mission       = '#workorder.Mission#'			
				 AND       RequirementId = WOL.WorkOrderItemId
				 
				) as Shipped
				
		FROM    WorkOrderLineItem WOL
		WHERE	WOL.WorkOrderId   = '#url.workorderid#' 
		AND     WOL.WorkOrderLine = '#url.workorderline#'
		
		<!--- only selecte items --->
		AND     WOL.WorkOrderitemId IN (#preserveSingleQuotes(form.selectline)#)
	   
</cfquery>
	
<!--- create batch --->

<CF_DateConvert>
<cfset dte = dateValue>		

<cfquery name="param" 
   datasource="AppsMaterials" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   	 SELECT   *
	 FROM     Ref_ParameterMission
	 WHERE    Mission = '#workorder.mission#' 
</cfquery>

<cfquery name="Parameter" 
   datasource="AppsMaterials" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	 SELECT    TOP 1 *
	 FROM      WarehouseBatch
	 ORDER BY  BatchNo DESC
</cfquery>

<cfif Parameter.recordcount eq "0">
	<cfset batchNo = 10000>
<cfelse>
	<cfset BatchNo = Parameter.BatchNo+1>
	<cfif BatchNo lt 10000>
	     <cfset BatchNo = 10000+BatchNo>
	</cfif>
</cfif>	

<cf_assignid>

<cfinvoke component = "Service.Process.WorkOrder.WorkorderLineItem"  
		   method           = "InternalWorkOrder" 
		   mission          = "#workorder.Mission#"
		   mode             = "view"
		   returnvariable   = "NotEarmarked">	

	<cftransaction>
		
		<!--- record the batch --->
		
		<cfset stat = "0">
						
		<cfquery name="Insert" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			INSERT INTO WarehouseBatch
				    (Mission,
					 Warehouse, 
					 BatchWarehouse,					
					 BatchReference,		
				 	 BatchNo, 	
					 BatchId,
					 BatchClass,
					 BatchDescription,						
					 TransactionDate,
					 TransactionType, 					
					 ActionStatus,
					 OfficerUserId, 
					 OfficerLastName, 
					 OfficerFirstName)
			VALUES ('#workorder.mission#',
				    '#form.warehouseto#',
					'#url.warehouse#',					
					'#Form.BatchReference#',
					'#batchNo#',	
					'#rowguid#',
					'WOEarmark',			 
					'Reserve stock',										
					#dte#,
					'8',		<!--- transfer --->			
					'#stat#',
					'#SESSION.acc#',
					'#SESSION.last#',
					'#SESSION.first#')
		</cfquery>				
		
		<cfloop query="Sale">
		
			<cfset balance = Quantity - Reserved>
												
			<cfquery name="getstock" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				
			    SELECT     T.ItemNo,	          
						   I.ItemDescription,
						   C.StockControlMode,
						   C.Category,
						   I.Classification,
						   T.TransactionUoM,
						   U.UoMDescription,	
						   U.ItemUoMId,			
						   T.Location, 
						   I.ItemPrecision,		           
						   T.TransactionLot, 
						   PL.TransactionLotSerialNo, 				 
						   T.WorkOrderId,
						   T.WorkOrderLine,
					       T.RequirementId,
						   ISNULL(SUM(T.TransactionQuantity), 0) AS OnHand 			 
						   
			    FROM       Materials.dbo.ItemTransaction T INNER JOIN	                            
				           Materials.dbo.Item I               ON I.ItemNo = T.ItemNo     INNER JOIN
						   Materials.dbo.Ref_Category C       ON C.Category = I.Category INNER JOIN
			               Materials.dbo.ItemUoM U            ON T.ItemNo = U.ItemNo AND T.TransactionUoM = U.UoM INNER JOIN
						   Materials.dbo.ProductionLot PL     ON T.Mission   = PL.Mission AND T.TransactionLot = PL.TransactionLot
						   
			    WHERE      T.Mission         = '#workorder.mission#' 
				AND        T.Warehouse       = '#url.warehouse#'		
				AND        T.ItemNo          = '#itemno#' 		
				AND        T.TransactionUoM  = '#uom#'
								
				<!--- not earmarked stock --->
				 AND       (
					         (T.RequirementId IS NULL) 
							  <cfif notearmarked neq ""> 	
							  OR 
							  T.RequirementId IN (#preservesingleQuotes(notearmarked)#)
							  </cfif>
						   )
									
				GROUP BY   T.ItemNo,
							   I.ItemDescription,
							   I.Classification,
							   I.ItemPrecision,
							   C.StockControlMode,
							   C.Category,
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
					
				ORDER BY I.ItemDescription,
				         T.ItemNo,
						 U.ItemUomId  					 		   
					   
			</cfquery> 
									
			<cfloop query="getStock">		
			
			<cfif balance gt 0>
			
				<cfif onhand gt balance>
					<cfset qty = balance>
					<cfset balance = 0>
				<cfelse>
					<cfset qty = onhand>
					<cfset balance = balance - onhand>	
				</cfif>	
				
				<cfset targetworkorderid   = url.workorderid>
				<cfset targetworkorderline = url.workorderline>
				<cfset targetrequirementid = sale.workorderitemid>	
								
				<cfquery name="AccountStock"
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    SELECT  GLAccount
						FROM    Ref_CategoryGLedger
						WHERE   Category  = '#Category#' 
						AND     Area      = 'Stock'
						AND     GLAccount IN (SELECT GLAccount 
						                      FROM   Accounting.dbo.Ref_Account)
				</cfquery>		
			
				<!--- first step we can look at the workorder account --->
																				
				<cfquery name="AccountVariance"
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    SELECT  GLAccount
						FROM    Ref_CategoryGLedger
						WHERE   Category = '#Category#' 
						AND     Area     = 'Variance'
						AND     GLAccount IN (SELECT GLAccount
						                      FROM Accounting.dbo.Ref_Account)
				</cfquery>				
								
				<cfif AccountVariance.recordcount eq "0" or AccountStock.recordcount eq "0">
				   
				   <table align="center">
				      	<tr>
						   <td class="labelit" align="center"><font color="FF0000">Attention : GL Account for stock and/or transfer has not been defined</td>
						</tr>
				   </table>		   
				   
					<script>
						Prosis.busy('no')
					</script>
		   
				   <cfabort>
				
				</cfif>
				
				<!--- if the stock is individual it is not supported here, 
				this is the hicosa mode for production --->
				
																													
				<cfif isValid("numeric",qty)>		
												
					<cfif qty neq 0>															
												
						<cf_assignid>	
											
						<cfset count = count+1>
						<cfset parid = rowguid>
						
						<!--- -------------------- --->
						<!--- -lower unearmarked-- --->
						<!--- -------------------- --->	
						
						<cf_StockTransact 
						    DataSource            = "AppsMaterials" 
							TransactionId         = "#rowguid#"	
						    TransactionType       = "8"  <!--- COGS --->
							TransactionSource     = "WorkorderSeries"
							ItemNo                = "#ItemNo#" 
							Mission               = "#workorder.Mission#" 
							Warehouse             = "#Warehouse#" 
							TransactionLot        = "#TransactionLot#" 						
							Location              = "#Location#"
							TransactionReference  = "#Form.BatchReference#"
							TransactionCurrency   = "#APPLICATION.BaseCurrency#"
							TransactionQuantity   = "#-qty#"
							TransactionUoM        = "#TransactionUoM#"						
							TransactionLocalTime  = "Yes"
							TransactionDate       = "#dateformat(now(),CLIENT.DateFormatShow)#"
							TransactionTime       = "#timeformat(now(),'HH:MM')#"
							TransactionBatchNo    = "#batchno#"												
							GLTransactionNo       = "#batchNo#"
							ActionStatus          = "#stat#"
							WorkOrderId           = "#workorderid#"
							WorkOrderLine         = "#workorderline#"	
							RequirementId         = "#requirementid#"																
							GLAccountDebit        = "#AccountVariance.GLAccount#"
							GLAccountCredit       = "#AccountStock.GLAccount#">
						
						<!--- -------------------- --->	
						<!--- --higher earmarked-- --->	
						<!--- -------------------- --->
						
						<cf_assignid>
						
						<cfif Form.LocationTo eq "">
							<cfset locationto = location>
						<cfelse>
						    <cfset locationto = form.locationto>
						</cfif>
						
						<!--- new warehouse / location --->
																								
						<cf_StockTransact 
						    DataSource            = "AppsMaterials" 
							TransactionId         = "#rowguid#"	
						    TransactionType       = "8"  <!--- transfer --->
							TransactionSource     = "WorkorderSeries"
							ItemNo                = "#ItemNo#" 
							Mission               = "#workorder.Mission#" 																					
							Warehouse             = "#Form.WarehouseTo#" 										
							Location              = "#LocationTo#"														
							TransactionLot        = "#TransactionLot#" 			
							TransactionReference  = "#Form.BatchReference#"
							TransactionCurrency   = "#APPLICATION.BaseCurrency#"
							TransactionQuantity   = "#qty#"
							TransactionUoM        = "#TransactionUoM#"						
							TransactionLocalTime  = "Yes"
							TransactionDate       = "#dateformat(now(),CLIENT.DateFormatShow)#"
							TransactionTime       = "#timeformat(now(),'HH:MM')#"
							TransactionBatchNo    = "#batchno#"												
							GLTransactionNo       = "#batchNo#"
							ParentTransactionId   = "#parid#"
							ActionStatus          = "#stat#"
							WorkOrderId           = "#targetworkorderid#"
							WorkOrderLine         = "#targetworkorderline#"	
							RequirementId         = "#targetrequirementId#"   <!--- important to keep the same --->					
							GLAccountCredit       = "#AccountVariance.GLAccount#"
							GLAccountDebit        = "#AccountStock.GLAccount#">											
						
					</cfif>									
												
				</cfif>
				
			 </cfif>	
						
		</cfloop>
		
		</cfloop>
		
	</cftransaction>
		
	<cfoutput>
	
		<script>		
			_cf_loadingtexthtml='';	
			// refresh the to box 
			ptoken.navigate('#SESSION.root#/WorkOrder/Application/Assembly/Items/FinalProduct/Reserve/WorkOrderListing.cfm?mission=#workorder.mission#&warehouse=#form.warehouseto#&workorderid=#url.workorderid#&workorderline=#url.workorderline#','orderbox')
			Prosis.busy('no')		
			ptoken.open('#session.root#/Warehouse/Application/Stock/Batch/BatchView.cfm?mode=process&trigger=workorder&mission=#workorder.mission#&batchno=#batchno#&systemfunctionid='+document.getElementById('systemfunctionid').value,'_blank','left=30, top=30, width=' + w + ', height= ' + h + ', toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=yes')
	
		</script>
   
	</cfoutput>   	
	
<cfelse>

		
	<cfoutput>
		
		<script>		
			_cf_loadingtexthtml='';	
			// refresh the to box 
			ptoken.navigate('#SESSION.root#/WorkOrder/Application/Assembly/Items/FinalProduct/Reserve/WorkOrderListing.cfm?mission=#workorder.mission#&warehouse=#form.warehouseto#&workorderid=#url.workorderid#&workorderline=#url.workorderline#','orderbox')
			Prosis.busy('no')		
		</script>
	   
	</cfoutput>   	

</cfif>