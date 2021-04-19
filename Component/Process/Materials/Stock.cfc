
<!--- components that related to stock and its valuation --->

<!--- 
	
	0a. get the on hand stock levels for an item of a mission, warehouse or stock location
	0b. get a table with stock levels
	
	1.	Apply LIFO/FIFO valuation to issuance transactions
		2.	Obtain transaction cost value (helper)
		2.	Apply
	3.  Process purchase receipt value changes
	4.  Set stock price (applies only to manual pricing)
	5.  Set stock ledger
	
--->
 
<cfcomponent>

    <cfproperty name="name" type="string">
    <cfset this.name = "Execution Queries for stock levels">
	
	<!--- --------------------------------- --->
	<!--- ----- 0. get stock values------- --->
	<!--- --------------------------------- --->
	
	<cffunction name="getStock"
        access="public"
        returntype="struct"
        displayname="1a get the status on the item/uom into a struct variable">
						
		<cfargument name="Mission"          type="string"  required="true"   default="">						
		<cfargument name="Warehouse"        type="string"  required="true"   default="">		
		<cfargument name="Location"         type="string"  required="true"   default="">	
		<cfargument name="TransactionLot"   type="string"  required="true"   default="">		
		<cfargument name="ItemNo"           type="string"  required="true"   default="">
		<cfargument name="UoM"              type="string"  required="true"   default="">
		<cfargument name="ExcludeBatchNo"   type="string"  required="true"   default="">
				
		<cfset stock.onhand       = "0">
		<cfset stock.earmarked    = "0">	
		<cfset stock.reserved     = "0">
						
		<!--- Check if UoM is managed in a particuarl transactionUoM --->
		<cfquery name="getUoMMission" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT TransactionUoM
				FROM   ItemUoMMission
				WHERE  ItemNo = '#ItemNo#' AND UoM = '#UoM#' AND Mission = '#Mission#'
		</cfquery>
		
		<!---
		
			If UoM is managed in a different UoM (the TransactionUoM), then the stock to be displayed for this UoM depends on the available stock of the TransactionUoM/multiplier.
			This is based on the fact that UoM managed in different UoM(the TransactionUoM) are not used in any warehouse transactions; because all its transactions will be expressed in the TransactionUoM.
			i.e. UoM = Bottle
				 UoM = Box, Multiplier = 12, TransactionUoM = Bottle
		--->
		
		<cfif  getUoMMission.recordcount gt 0 and getUoMMission.TransactionUoM neq "">
		
			<!--- Get stock of the TransactionUoM --->
			<cfinvoke component = "Service.Process.Materials.Stock"  
			   method           = "getStock" 
			   warehouse        = "#Warehouse#" 							  
			   ItemNo           = "#ItemNo#"
			   UoM              = "#getUoMMission.TransactionUoM#"		
			   TransactionLot   = "#TransactionLot#"					  
			   returnvariable   = "stockTransactionUoM">					   
			   
			<!--- Get Multiplier --->
			<cfquery name="getUoM" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT UoMMultiplier
				FROM   ItemUoM
				WHERE  ItemNo = '#ItemNo#' AND UoM = '#UoM#'
			</cfquery>

			<cfif getUoM.UoMMultiplier gt 0>
			
				<cfset stock.onhand   = stockTransactionUoM.onhand / getUoM.UoMMultiplier>
				<cfset stock.reserved = stockTransactionUoM.reserved / getUoM.UoMMultiplier>
			
			</cfif>
		
		<cfelse>
				
			<cfquery name="getOnhand" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT    SUM(TransactionQuantity) AS Total
				FROM      ItemTransaction
				WHERE     1=1
				<cfif Mission neq "">
				AND       Mission        = '#mission#' 
				</cfif>
				<cfif Warehouse neq "">
				AND       Warehouse      = '#warehouse#'
				</cfif>
				<cfif Location neq "">
				AND       Location       = '#location#'
				</cfif>
				<cfif TransactionLot neq "">
				AND       TransactionLot = '#transactionlot#'
				</cfif>
				<!--- not earmarked --->
				AND       WorkOrderId is NULL
				
				AND       ItemNo         = '#itemNo#' 
				AND       TransactionUoM = '#UoM#'		
				
				<!--- Hanno 10/7/2019 
						likely we need to be more granular based on the transactiontype 
						and the actionstatus of the transaction to be included 
						receipt likely best to be status = '1'
						issuance / transfer/ variation like best to be 0 and 1
				--->						
				
				<cfif excludeBatchNo neq "">
				AND     (TransactionBatchNo != '#excludeBatchNo#' OR TransactionBatchNo IS NULL)
				</cfif>	
			</cfquery>	
			
			<cfif getOnHand.Total neq "">
			    <cfset stock.onhand  = "#getOnHand.total#">
			</cfif>
			
			<!--- sales order reservation : workorder module commitment --->
			
			<cfquery name="getEarmarked" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT    SUM(TransactionQuantity) AS Total
				FROM      ItemTransaction
				WHERE     1=1
				<cfif Mission neq "">
				AND       Mission        = '#mission#' 
				</cfif>
				<cfif Warehouse neq "">
				AND       Warehouse      = '#warehouse#'
				</cfif>
				<cfif Location neq "">
				AND       Location       = '#location#'
				</cfif>
				<cfif TransactionLot neq "">
				AND       TransactionLot = '#transactionlot#'
				</cfif>
				<!--- not earmarked --->
				AND       WorkOrderId is NOT NULL
				
				AND       ItemNo         = '#itemNo#' 
				AND       TransactionUoM = '#UoM#'		
									
				
				<cfif excludeBatchNo neq "">
				AND     (TransactionBatchNo != '#excludeBatchNo#' OR TransactionBatchNo IS NULL)
				</cfif>	
				
			</cfquery>	
			
			<cfset stock.earmarked = getEarmarked.total>			
						
			<!--- stock internal request : Request --->
			
			<cfquery name="getReserved" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT    R.RequestId, 
				          RequestedQuantity as Requested,
						  
				          (SELECT ISNULL(SUM(TransactionQuantity),0)
						   FROM   ItemTransaction
						   WHERE  Requestid = R.RequestId
						   AND    TransactionQuantity < 0 ) as Issued  
						   
				FROM      Request R
				WHERE     1=1
				AND       Status NOT IN ('3','9')	<!--- means it was processed --->		    
				<cfif mission neq "">
				AND       Mission = '#mission#' 
				</cfif>
				<cfif warehouse neq "">
				AND       Warehouse = '#warehouse#'
				</cfif>			
				AND       ItemNo         = '#itemNo#' 
				AND       UoM            = '#UoM#'								
			</cfquery>	
			
			<cfloop query="getReserved">
			
			  	<cfset stock.reserved = stock.reserved + (getReserved.Requested - getReserved.Issued)>
									
			</cfloop>			
		
		</cfif>
		
		<cfreturn stock>	
		
	</cffunction>		

	
	<!--- --------------------------------- --->
	<!--- ----- 0b. get stock list -------- --->
	<!--- --------------------------------- --->
		
	<cffunction name="getStockListing"
        access="public"
        returntype="struct"
        displayname="1b. get a listing of items with their current stock levels">
		
			<cfargument name="Mission"    type="string"  required="true"   default="">						
			<cfargument name="Warehouse"  type="string"  required="false"  default="">		
			<cfargument name="Location"   type="string"  required="false"  default="">		
			
			<cfargument name="ItemNo"     type="string"  required="true"   default="">
			<cfargument name="UoM"        type="string"  required="true"   default="">
			
			<cfargument name="Mode"       type="string"  required="true"   default="Table">
			<cfargument name="Table"      type="string"  required="false"  default="#SESSION.acc#Stock">
							
			<cfquery name="stock" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				
					SELECT	<cfif warehouse neq "">IWL.Warehouse</cfif>,
					        <cfif location  neq "">IWL.Location</cfif>,
							IWL.ItemNo,
							IWL.UoM,
							I.ItemDescription,
							I.ItemPrecision,
							U.UoMDescription,
							I.ItemMaster,
							
							ISNULL((
								SELECT 	SUM(TransactionQuantity)
								FROM   	ItemTransaction					
								WHERE   Mission        = '#mission#' 	
								<cfif warehouse neq "">		
									AND  	Warehouse      = '#warehouse#'
								</cfif>
								<cfif location neq "">		
									AND  	Location       = '#location#'
								</cfif>
								AND		ItemNo         = '#itemno#'
								AND		TransactionUoM = '#uom#'
							),0) OnHand,
							
							SUM(IWL.HighestStock) as HighestStock,
							SUM(IWL.MaximumStock) as MaximumStock,
							SUM(IWL.MinimumStock) as MinimumStock
					FROM	ItemWarehouseLocation IWL
							INNER JOIN WarehouseLocation WL       ON WL.Warehouse = IWL.Warehouse AND WL.Location = IWL.Location
							INNER JOIN Item I    	              ON IWL.ItemNo = I.ItemNo
							INNER JOIN ItemUoM U	              ON IWL.ItemNo = U.ItemNo AND IWL.UoM = U.UoM				
					WHERE   Warehouse IN (SELECT Warehouse FROM Warehouse WHERE Mission = '#mission#'
					<cfif warehouse neq "">		
					AND  	WL.Warehouse      = '#warehouse#'
					</cfif>
					<cfif location neq "">		
					AND  	WL.Location       = '#location#'
					</cfif>								
					GROUP BY <cfif warehouse neq "">IWL.Warehouse</cfif>,
					         <cfif location  neq "">IWL.Location</cfif>,
							 IWL.ItemNo,
							 IWL.UoM,
							 I.ItemDescription,
							 I.ItemPrecision,
							 U.UoMDescription,
							 I.ItemMaster
					ORDER BY I.ItemDescription, 
					         U.UoMDescription,
						
			</cfquery>
		
	</cffunction>	
	
	<!--- ----------------------------------------------------- --->
	<!--- ----- 0b. get transactions under a GLAccount -------- --->
	<!--- ----------------------------------------------------- --->
	
	<cffunction name="getStockLedger"
        access="public"
        returntype="struct"
        displayname="1b. get a listing of stock transactions with their financial values">
		
			<cfargument name="Mission"    type="string"  required="true"   default="">						
			<cfargument name="GLAccount"  type="string"  required="false"  default="">		
			<cfargument name="Mode"       type="string" required="true"  default="Table">
			<cfargument name="Table"      type="string" required="false" default="#SESSION.acc#Allotment">
			
			<cfquery name="stock" 
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
			
					SELECT        TOP (100) PERCENT 
					              Journal, JournalSerialNo, 
				                  GLAccount, 
								  AmountLedger, 
								  AmountStock, 
								  Difference, 
								  ReferenceId as TransactionId,
				                  TransactionType, 
							      TransactionDate, 
								  WorkOrderId, 
								  ItemNo, 
				                  ItemDescription, 
								  ItemCategory,
				                  (SELECT    ValuationCode
				                   FROM      Materials.dbo.Item
				                   WHERE     ItemNo = DT.ItemNo) AS Valuation, 
								  TransactionBatchNo, 
								  Created
								  
					<cfif Mode eq "Table">
					INTO      userquery.dbo.#table#					
					</cfif>			  
											 
					FROM            (SELECT        TOP (100) PERCENT Journal, JournalSerialNo, GLAccount, AmountLedger, AmountStock, ROUND(AmountLedger - AmountStock, 0) AS Difference, 
				                                   ReferenceId, TransactionType, TransactionDate, WorkOrderId, ItemNo, ItemDescription, ItemCategory, TransactionBatchNo, Created
																	
				                     FROM            (SELECT        TOP (100) PERCENT TL.Journal, TL.JournalSerialNo, TL.TransactionDate, TL.GLAccount, 
				                                                    TL.AmountBaseDebit - TL.AmountBaseCredit AS AmountLedger, S.TransactionValue AS AmountStock, TH.ReferenceId, S.ItemCategory, 
				                                                    S.ItemDescription, S.TransactionBatchNo, S.Created, S.ItemNo, S.TransactionType, S.WorkOrderId
				                                      FROM          Accounting.dbo.TransactionLine AS TL INNER JOIN
				                                                    Accounting.dbo.TransactionHeader AS TH ON TL.Journal = TH.Journal AND TL.JournalSerialNo = TH.JournalSerialNo LEFT OUTER JOIN
				                                                   Materials.dbo.ItemTransaction AS S ON TH.ReferenceId = S.TransactionId
																   
				                                      WHERE        TL.GLAccount IN (#GLAccount#)
													  
				                                      ORDER BY     TH.TransactionId) AS derivedtbl_1
				                     ORDER BY TransactionDate) AS DT
									 
					ORDER BY ItemNo, TransactionDate
			
			</cfquery>	
	
	</cffunction>	
	
	<!--- ---------------------------------------------- --->
	<!--- ----- 1. process LIFO/FIFO valuation--- ------ --->
	<!--- ---------------------------------------------- --->
	
	<cffunction name="redoIssuanceTransaction"
        access="public"
        returntype="any"
        displayname="Source an issuance transaction and revaluate and post the amounts">
							
		<cfargument name="Mode"          type="string" 	default="Standard" required="yes">	
		<cfargument name="filterMission" type="string" 	default=""         required="yes">
		<cfargument name="filterItemNo"  type="string" 	default=""         required="yes">	
		<cfargument name="revaluation"   type="string" 	default="0"        required="yes">	
		<cfargument name="initialStatus" type="numeric" default="0"        required="yes">	
		<cfargument name="finalStatus"   type="numeric" default="1"        required="yes">	
		
		<!--- precision --->		
		<cfset precision = "5">
		
		<cfset corr = "1">		
		<cfloop index="itm" from="1" to="#precision#">
			<cfset corr = "#corr#0">
		</cfloop>
					
		<!--- general mistake in the transaction valuation which needs to be reprocessed --->	
				
		<!--- obtain the cuttofdate --->
		<cfquery name="param" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT * 
			FROM   Materials.dbo.Ref_ParameterMission
			WHERE  Mission = '#filtermission#' 						
		</cfquery>		
		
		<cfif mode neq "Force">
							
				<cfif filterMission neq "" and filterItemNo neq "">
									
					<!--- 1. this triggers an enforced reload --->
					
					<cfquery name="reset" 
							datasource="AppsMaterials" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							DELETE FROM Materials.dbo.ItemTransactionValuation
							WHERE  DistributionTransactionId IN
			                             (SELECT  TransactionId
			                              FROM    ItemTransaction T
			                              WHERE   Mission = '#filtermission#' 
										  AND     ItemNo  = '#filteritemno#'
										  <!--- added 
										  AND     TransactionDate >= (SELECT RevaluationCutoff
										                              FROM   ItemUoMMission
																	  WHERE  Mission = T.Mission
																	  AND    ItemNo  = T.ItemNo
																	  AND    UoM     = T.TransactionUoM)
																	  
																	  --->
										  <!--- added 3/11/2016 --->
										  AND     TransactionDate >= '#param.RevaluationCutoff#'
										  )		
					</cfquery>					  
				
				</cfif>
		
				<!--- 2. additional transactions to be revaluated because there is something wrong --->
				
				<cfquery name="transactions" 
						datasource="AppsMaterials" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							
							SELECT      TransactionId, 
							            TransactionValue, 
										Valuation AS IncorrectValuation, 
										Created
										
							FROM        (SELECT   TransactionId, 
							                      Created, 
												  TransactionValue,
			                                 	  (SELECT   ISNULL(SUM(TransactionCostPriceValue) * - 1, 0) 
			                                       FROM     Materials.dbo.ItemTransactionValuation
				                                   WHERE    DistributionTransactionId = V.TransactionId) AS Valuation
												   
			               		        FROM      ItemTransaction AS V
			                        	WHERE     TransactionQuantity < 0
										
										<!--- added 3/11/2016 --->
										AND       TransactionDate > '#param.RevaluationCutoff#') AS derivedtbl_1
										 
							WHERE       ABS(TransactionValue - Valuation) > 0.01					
							
				</cfquery>		
						
				<cfloop query="transactions">
					
						<cfquery name="clear" 
							datasource="AppsMaterials" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								DELETE FROM Materials.dbo.ItemTransactionValuation
								WHERE  DistributionTransactionId = '#transactionid#'
						</cfquery>
						
				</cfloop>	
		
				<!--- ----------------------------------------------------------- --->
				<!--- 3. we remove also the internally sourced transactions as wrong --->
				<!--- ----------------------------------------------------------- --->
				
				<cfif Mode eq "Extended">			
					
					<!--- remove transactions sourced by themselves, so we revaluate and see if we find stock to take it from  --->
					
					<cfquery name="transactions" 
							datasource="AppsMaterials" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">	
					
							DELETE FROM Materials.dbo.ItemTransactionValuation
							WHERE       DistributionTransactionId = TransactionId		
					
					</cfquery>		
				
				</cfif>
		
				<!--- 
				
				define all issuance transactions that are not or no longer sourced / incorrectly sourced 
				
					Sort in order of transaction date 
					apply the sourcing component => creates record
					calculate the total value and update itemtransaction price + value & the glaccountdebit glaccountcredit
					
					determine the debit/credit glaccount
					
					update the GL header values (referenceid)
					update the GL transactionlines GL account 1 (cost) and 2 (stock) and Value and debit credit
					
						(If the line does not exist we have 2 headers without lines)	
						
					9/8/16 : we also added support to correct the postive transaction in case of a transfer 8/6 
									
				--->	
		
				<cfquery name="getlines" 
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">	
					SELECT     *, (SELECT TransactionId 
					               FROM   ItemTransaction 
								   WHERE  ParentTransactionId = I.TransactionId
								   AND    TransactionType = '8') as ChildId
					FROM       ItemTransaction AS I
					WHERE      TransactionQuantity < 0 			
					<cfif filterMission neq "">
					AND        Mission = '#filterMission#'
					</cfif>
					<cfif filterItemNo neq "">
					AND        ItemNo = '#filterItemNo#'
					</cfif>
					AND        NOT EXISTS  (SELECT  'X' AS Expr1
		      		                   		FROM    Materials.dbo.ItemTransactionValuation
			               		            WHERE   DistributionTransactionId = I.TransactionId)	
											
					ORDER BY TransactionDate, 
							 Created,
							 ParentTransactionId  <!--- first the negative, then the positive --->														
											
				</cfquery>		
				
		<cfelse>
		
			<cfquery name="getLines"
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				
				        SELECT I.*, StandardCost, StockQuantity, StockValue, '' as ChildId 
						FROM   ItemTransaction I INNER JOIN (
					
					
							SELECT  TOP 100 PERCENT
							   
									(SELECT     TOP (1) TransactionId
		                                FROM      ItemTransaction
		                                WHERE     Mission = T.Mission 
									    AND       ItemNo = T.ItemNo 
									    AND       TransactionUoM = T.TransactionUoM 
									    AND       TransactionLot = T.TransactionLot 
									    AND       TransactionQuantity < 0 
									    AND       Warehouse = T.Warehouse
		                                ORDER BY Created DESC) AS TransactionId,
										
										T.Mission, 
							            T.Warehouse, 
										T.ItemNo, 
										R.ItemDescription,
										R.ItemPrecision,
										T.TransactionUoM, 
										I.StandardCost, 
										T.TransactionLot, 
										ROUND(SUM(T.TransactionQuantity), R.ItemPrecision) AS StockQuantity, 
		                    	        ROUND(SUM(T.TransactionValue)   , R.ItemPrecision) AS StockValue									
		                               
									   
							FROM       ItemTransaction AS T INNER JOIN
		                    		   ItemUoMMission AS I ON T.ItemNo = I.ItemNo AND T.TransactionUoM = I.UoM AND T.Mission = I.Mission INNER JOIN
									   Item R ON T.ItemNo = R.ItemNo
									   
							WHERE      T.ItemNo  = '#filterItemNo#' 
							AND        T.Mission = '#filterMission#'
							GROUP BY   T.Mission, 
							           T.Warehouse, 
									   T.ItemNo, 
									   R.ItemPrecision,
									   R.ItemDescription, 
									   T.TransactionUoM, 
									   T.TransactionLot, 
									   I.StandardCost
							
							<!--- define items that have a strange valuation at the end --->
							
							HAVING      (
										ROUND(SUM(T.TransactionQuantity), R.ItemPrecision) = 0 
										OR
		                                ABS(ROUND(SUM(T.TransactionValue), R.ItemPrecision) 
										  / ROUND(SUM(T.TransactionQuantity), R.ItemPrecision)) > I.StandardCost * 2
										  
										) AND (ROUND(SUM(T.TransactionValue), R.ItemPrecision) <> 0)
										
							ORDER BY   T.Warehouse
							
							) as J ON I.TransactionId = J.TransactionId
																			
			</cfquery>	
		
		</cfif>				
		
		<cfset session.status = initialStatus>

		<cfloop query="getlines">
		
			<cfif mode neq "Force">
		
				<!--- obtain the valuation of this transaction see other routine --->						
							
				<cfinvoke component      = "Service.Process.Materials.Stock"  
					method               = "getItemValuation" 
					datasource           = "AppsMaterials"
					transactionQuantity  = "#TransactionQuantity#"
					transactionDate      = "#dateformat(TransactionDate,client.dateformatshow)#"
					Mission              = "#Mission#"
					TransactionId        = "#TransactionId#"
					Warehouse            = "#Warehouse#"
					Location             = "#Location#"
					TransactionLot       = "#TransactionLot#"
					TransactionUoM       = "#TransactionUoM#"
					ItemNo			     = "#ItemNo#"
					TransactionIdOrigin  = "#TransactionIdOrigin#"
					WorkOrderId          = "#WorkOrderId#">
						
				<!--- obtain the results and apply --->
				
				<cfquery name="getValue" 
				   datasource="AppsMaterials" 
				   username="#SESSION.login#" 
				   password="#SESSION.dbpw#">			   
				   SELECT    SUM(TransactionCostPriceValue) AS Value
			       FROM      ItemTransactionValuation
				   WHERE     DistributionTransactionId = '#TransactionId#' 
			     </cfquery>
				 
				 <cfset newtransactionValue    = getValue.Value>
				 
			<cfelse>
			
				<!--- current stock value versus desire value --->
				<cfset correction = (standardcost * stockquantity) - stockvalue>
			
				<cfquery name="getValue" 
				   datasource="AppsMaterials" 
				   username="#SESSION.login#" 
				   password="#SESSION.dbpw#">			   
				   SELECT    TransactionValue
			       FROM      ItemTransaction
				   WHERE     TransactionId = '#TransactionId#' 
			     </cfquery>
			
				<!--- define corrected quantity for the final line --->
				<cfset newtransactionvalue = (getValue.transactionValue + correction)*-1>		
			
			</cfif>	 
			 			 	 			 
			 <!--- if this transaction is a transfer transaction, we now also track down the counter part and update this one 
			 with the newly assigned value --->
						 
			  <cfquery name="Item" 
			   datasource="AppsMaterials" 
			   username="#SESSION.login#" 
			   password="#SESSION.dbpw#">
				   SELECT *
				   FROM  Item
				   WHERE ItemNo = '#itemno#'			  
		     </cfquery>
			 
			  <cfquery name="StockAccount" 
			   datasource="AppsMaterials" 
			   username="#SESSION.login#" 
			   password="#SESSION.dbpw#">
					SELECT   *
					FROM     Ref_CategoryGledger
					WHERE    Category = '#Item.Category#' 
					AND      Area = 'Stock'
			 </cfquery>
			 
			 <cfset glcredit = StockAccount.GLAccount>		
			 	 
			 <cfset gldebit  = glaccountDebit>
			 			 
			 <cfswitch expression="#TransactionType#">
			 
				 <cfcase value="2">
				 
					  <cfquery name="getAccount" 
					   datasource="AppsMaterials" 
					   username="#SESSION.login#" 
					   password="#SESSION.dbpw#">
							SELECT   *
							FROM     Ref_CategoryGledger
							WHERE    Category = '#Item.Category#' 
							AND      Area = 'COGS'
					 </cfquery>	
					 
					 <cfset gldebit  = getAccount.GLAccount>		 	
				 			 		 
				 </cfcase>
				 
				 <cfcase value="5">			 
				 
				 	 <cfquery name="getAccount" 
					   datasource="AppsMaterials" 
					   username="#SESSION.login#" 
					   password="#SESSION.dbpw#">
							SELECT   *
							FROM     Ref_CategoryGledger
							WHERE    Category = '#Item.Category#' 
							AND      Area = 'Variance'
					 </cfquery>	
					 
					 <cfset gldebit  = getAccount.GLAccount>		
				 			 		 
				 </cfcase>
				 
				  <cfcase value="8">			 
				 
				 	 <cfquery name="getAccount" 
					   datasource="AppsMaterials" 
					   username="#SESSION.login#" 
					   password="#SESSION.dbpw#">
							SELECT   *
							FROM     Ref_CategoryGledger
							WHERE    Category = '#Item.Category#' 
							AND      Area = 'Variance'
					 </cfquery>	
					 					 
					 <cfset gldebit  = getAccount.GLAccount>		
				 			 		 
				 </cfcase>			 
			 
			 </cfswitch> 					 			 
			 
			 <!--- ------------------------------------------- --->
			 <!--- important correction for internal transfers --->
			 <!--- ------------------------------------------- --->
			 			 
			 <cfif ChildId neq "">
			 	
				<cfif revaluation eq "1">										
				 	<cfset ids = "#TransactionId#,#ChildId#">	
				<cfelse>				
					<cfset ids = TransactionId>		
				</cfif>
								
			 <cfelse>
			 
			 	<cfset ids = TransactionId>
			 
			 </cfif> 			 					
						 
			 <cfset cnt = 0>
					 
			 <!--- loop through the (1) or (2) transaction --->
			 
			 <cfloop index="traid" list="#ids#">
			 
			
			 
						 
			 	<cfset cnt = cnt + 1>
				
				<cfset val = round(newTransactionValue*corr)/corr>	
												
				<cfquery name="getTra" 
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">					  
						SELECT T.*
						FROM   Materials.dbo.ItemTransaction T 			   
						WHERE  TransactionId = '#TraId#' 					  						   
			    </cfquery>		
				
				 <cfquery name="getGL"
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT H.* 
						FROM   Accounting.dbo.TransactionHeader H INNER JOIN Accounting.dbo.TransactionLine L 
						       ON H.Journal = L.Journal AND H.JournalSerialNo = L.JournalSerialNo
						WHERE  H.ReferenceId = '#TraId#' 
						AND    H.RecordStatus <> '9' 
						AND    H.ActionStatus <> '9'
				</cfquery>
																
				<cfif cnt eq "1">
					<cfset diff = round((val+getTra.TransactionValue)*corr)/corr> 				 
				<cfelse>
				    <!--- the plus part --->
				    <cfset diff = round((val-getTra.TransactionValue)*corr)/corr> 
				</cfif>	
				
				<cfif diff neq "0" or getGL.recordcount eq "0">		<!--- Hanno : 6/27/2017 we need to add also a comparison with the posted value, not just existance --->		
																						
					<cfif cnt eq "1">								 
				 
						 <cfquery name="setTransaction" 
						   datasource="AppsMaterials" 
						   username="#SESSION.login#" 
						   password="#SESSION.dbpw#">		
						  				
							   UPDATE    Materials.dbo.ItemTransaction
							   SET       TransactionValue     = '#val*-1#',
							   			 TransactionCostPrice = '#abs(round(val*corr/TransactionQuantity)/corr)#',									 
										 GLAccountDebit       = '#gldebit#',  <!--- cost account --->
										 GLAccountCredit      = '#glcredit#'  <!--- stock account --->			 
							   WHERE     TransactionId = '#TraId#' 					  						   
					     </cfquery>
						 
					<cfelse>
					
						 <!--- increase the stock by reversing this transaction --->
						 
						 <!--- reverse the value of debit/credit do not change --->
						 
						 <cfset x = gldebit>					 
						 <cfset gldebit  = glcredit>
						 <cfset glcredit = x>					  
										
						 <cfquery name="setTransaction" 
						   datasource="AppsMaterials" 
						   username="#SESSION.login#" 
						   password="#SESSION.dbpw#">		
						  			   
							   UPDATE    Materials.dbo.ItemTransaction
							   SET       TransactionValue     = '#val#',
							   			 TransactionCostPrice = '#abs(round(val*corr/TransactionQuantity)/corr)#',
										 GLAccountDebit       = '#gldebit#',
										 GLAccountCredit      = '#glcredit#'	
							   WHERE     TransactionId = '#TraId#' 								  
					     </cfquery>				
					
					</cfif>	 		
					
					<!--- apply the financials --->		
				 			 
					 <!--- update the header and the lines --->					 			 
					
					
					<cfif getGL.recordcount eq "0">
					
						<!--- we create a ledger transaction as it was missing in the first place
						because of whatever reason --->
						
						<cfquery name="Warehouse" 
					    datasource="AppsMaterials" 
					    username="#SESSION.login#" 
					    password="#SESSION.dbpw#">
						    SELECT    *
						    FROM      Warehouse
							WHERE     Warehouse = '#Warehouse#'
					    </cfquery> 
						
						<cfquery name="Clear" 
					    datasource="AppsMaterials" 
					    username="#SESSION.login#" 
					    password="#SESSION.dbpw#">
						    DELETE FROM Accounting.dbo.TransactionHeader
							WHERE  ReferenceId = '#TraId#'						    
					    </cfquery> 
						
						<cfset orgunitOwner = "0">
						
						<cfquery name="Parameter" 
					    datasource="AppsMaterials" 
					    username="#SESSION.login#" 
					    password="#SESSION.dbpw#">
						    SELECT    *
						    FROM      Accounting.dbo.Ref_ParameterMission
							WHERE     Mission = '#Mission#'
					    </cfquery> 
					  
					    <!--- this entity posts by parent  --->
					
					    <cfif Parameter.AdministrationLevel eq "Parent">
					  
					        <!--- determine a default owner --->
					
							<cfif Attributes.OrgUnitOwner eq "0">
							
							  <cfquery name="getOwner" 
							    datasource="#Attributes.DataSource#" 
							    username="#SESSION.login#" 
						    	password="#SESSION.dbpw#">
									SELECT    TOP 1 OrgUnit
									FROM      Organization.dbo.Organization O
									WHERE     Mission = '#mission#'
									AND       OrgUnitCode IN
						                          (SELECT     TOP 1 HierarchyRootUnit
						                            FROM      Organization.dbo.Organization
													WHERE     Mission          = O.Mission							
						                            AND       MissionOrgUnitId = '#warehouse.MissionOrgUnitId#'
						                            ORDER BY  Created DESC
												)		
									ORDER BY Created DESC					
								</cfquery>
							
								<cfif getOwner.recordcount eq "1">
								
									<cfset OrgUnitOwner = getOwner.OrgUnit>
								 
								</cfif>					
								
							</cfif>
							
					    </cfif>
						
						<cfquery name="getJournal" 
					    datasource="appsMaterials" 
					    username="#SESSION.login#" 
					    password="#SESSION.dbpw#">
							SELECT    *
							FROM      Accounting.dbo.Journal
							WHERE     Mission       = '#Mission#' 
							AND       SystemJournal = 'Warehouse'
							AND       Currency      = '#Application.BaseCurrency#'  
					    </cfquery>					
						
					    <cfif getJournal.recordcount eq "0">
									
							<cf_waitEnd> 							
							<cf_message message = "A Facility Journal for currency: #Application.BaseCurrency# was not defined. Operation not allowed." return = "back">
							<cfabort>
						  
					    </cfif> 								
						
						<cf_GledgerEntryHeader
							    DataSource            = "appsMaterials"
								Mission               = "#Mission#"
								OrgUnitOwner          = "#OrgUnitOwner#"
								Journal               = "#getJournal.Journal#" 						
								TransactionSource     = "WarehouseSeries"												
								TransactionCategory   = "Memorial"						
								MatchingRequired      = "0"
								ActionStatus          = "1"
								Reference             = "Warehouse"       
								ReferenceName         = "#ItemNo# #left(Itemdescription,100)#"
								ReferenceId           = "#TraId#"
								ReferenceNo           = ""
								TransactionDate       = "#dateformat(TransactionDate,client.dateformatshow)#"
								DocumentCurrency      = "#Application.BaseCurrency#"
								DocumentDate          = "#dateformat(TransactionDate,client.dateformatshow)#"
								DocumentAmount        = "#val#"
								AmountOutstanding     = "0">
								
					<cfelse>
					
						<cfif getGL.Reference eq "Warehouse">
					
							<!--- Sale transactions we do not change the header amount as this refers to the sale --->
							
							<cfquery name="setGLTransaction"
								datasource="AppsMaterials" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
								UPDATE  Accounting.dbo.TransactionHeader
								SET     DocumentAmount       = '#val#',
									    Amount               = '#val#'				
								WHERE   ReferenceId          = '#TraId#' 
							</cfquery>
					
						</cfif>								
					
					</cfif>
														
					<cfquery name="getGL"
						datasource="AppsMaterials" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT * 
							FROM   Accounting.dbo.TransactionHeader			
							WHERE  ReferenceId = '#TraId#' 
					</cfquery>		
							
					<!--- get the 2 lines of the distribution, 
					   sometimes they have tax booking associated under 3 and 4 in case of Sale --->
							
					<cfquery name="getGLLines"
						datasource="AppsMaterials" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT   * 
							FROM     Accounting.dbo.TransactionLine			
							WHERE    Journal         = '#getGL.Journal#'
							AND      JournalSerialNo = '#getGL.JournalSerialNo#'	
							AND      TransactionSerialNo IN ('1','2')		
							ORDER BY TransactionSerialNo
					</cfquery>
					
						<cfif getGLLines.recordcount eq "0">
						
								<!--- create header or lines --->
						
								<cfquery name="Type"
								datasource="AppsMaterials" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
									SELECT   * 
									FROM     Ref_TransactionType			
									WHERE    TransactionType = '#transactiontype#'					
								</cfquery>		
								
								<cfif workorderid neq "">
								
									<cfquery name="Work"
									datasource="AppsMaterials" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
										SELECT   * 
										FROM     WorkOrder.dbo.WorkOrderLine
										WHERE    WorkOrderId   = '#workorderid#'
										AND      WorkOrderLine = '#workorderline#'									
									</cfquery>			
								
									<cfset workid = work.workorderlineId>
								
								<cfelse>
								
									<cfset workid = "">
									
								</cfif>					
								
								<cf_GledgerEntryLine
									    DataSource            = "AppsMaterials"
										Lines                 = "2"
										TransactionDate       = "#dateformat(getGL.TransactionDate,client.dateformatshow)#"
										Journal               = "#getGL.Journal#"
										JournalNo             = "#getGL.JournalSerialNo#"
										JournalTransactionNo  = "#getGL.JournalTransactionNo#"
										AccountPeriod         = "#getGL.AccountPeriod#"
										Currency              = "#getGL.Currency#"
																												
										TransactionSerialNo1  = "1"
										Class1                = "Debit"
										Reference1            = "COGS"       
										ReferenceName1        = "#left(Itemdescription,100)#"
										Description1          = "#Type.Description#"
										GLAccount1            = "#gldebit#"
										Costcenter1           = "#orgunit#"
										WorkOrderLineId1      = "#workid#"
										ReferenceId1          = "#TraId#"
										ReferenceNo1          = "#ItemNo#"
										TransactionType1      = "Standard"
										Amount1               = "#val#"
											
										TransactionSerialNo2  = "2"
										Class2                = "Credit"
										Reference2            = "Stock"       
										ReferenceName2        = "#left(Itemdescription,100)#"
										Description2          = "#Type.Description#"
										GLAccount2            = "#glcredit#"
										Costcenter2           = "#orgunit#"
										WorkOrderLineId2      = "#workid#"
										ReferenceNo2          = "#ItemNo#"
										ReferenceId2          = "#TraId#"
										TransactionType2      = "Standard"
										Amount2               = "#val#">			
						
						<cfelse>
						
							<!--- we also log the transaction after the change --->
					
							<cfinvoke component    = "Service.Process.GLedger.Transaction"  
								   method              = "LogTransaction" 
								   datasource          = "AppsMaterials" 
								   Journal             = "#getGL.Journal#"
								   JournalSerialNo     = "#getGL.JournalSerialNo#"			   
								   Action              = "Valuation">	  
								
							<cfloop query="getGLLines">
											
								<cfset tradte = dateFormat(TransactionDate, CLIENT.DateFormatShow)>
								
								<!--- A. we rework the base currency amount into a transaction currency as set in the transaction header
								in case of Sales, this can be different from the base currency --->
							
								<cfif TransactionCurrency eq application.BaseCurrency>	
													
									<cfset valdocument = val>		
												
								<cfelse>	
								
									<cf_exchangeRate datasource = "appsMaterials"
										EffectiveDate       = "#tradte#"
								        CurrencyFrom        = "#application.BaseCurrency#"
										CurrencyTo          = "#TransactionCurrency#"> 		
														
									<cfset valdocument = val/exc>	
																			
								</cfif>
								
								<cfif Currency eq application.BaseCurrency>						
									<cfset valjournal = val>	
														
								<cfelse>				
														
									<cf_exchangeRate datasource = "appsMaterials"
										EffectiveDate       = "#tradte#"
								        CurrencyFrom        = "#application.BaseCurrency#"
										CurrencyTo          = "#Currency#"> 		
											
									<cfset valjournal = val/exc>		
											
								</cfif>		
								
								<!--- B. now we rework the currencies exchange rate from the perspective of the transaction currecny --->							
								
								<cf_exchangeRate datasource = "appsMaterials"
									EffectiveDate       = "#tradte#"
							        CurrencyFrom        = "#TransactionCurrency#"
									CurrencyTo          = "#Currency#"> 		
									
								<cfset excjournal = exc>	
									
								<cf_exchangeRate datasource = "appsMaterials"
									EffectiveDate       = "#tradte#"
							        CurrencyFrom        = "#TransactionCurrency#"
									CurrencyTo          = "#application.BaseCurrency#"> 			
									
								<cfset excbase = exc>									
						
								<cfquery name="setGLTransaction"
									datasource="AppsMaterials" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
								
									<!--- cost booking --->
								
									UPDATE Accounting.dbo.TransactionLine
									SET    GLAccount            = '#gldebit#',
										   TransactionAmount    = '#valdocument#',
										   ExchangeRate         = '#excjournal#', 
										   AmountCredit         = '0',
										   AmountDebit          = '#valjournal#',
										   ExchangeRateBase     = '#excbase#', 
										   AmountBaseCredit     = '0',
										   AmountBaseDebit      = '#val#'	
									WHERE  TransactionLineId    = '#TransactionLineId#'				
									AND    TransactionSerialNo  = '1'
									
									<!--- stock booking : deduction from stock --->
									
									UPDATE Accounting.dbo.TransactionLine
									SET    GLAccount            = '#glcredit#',
										   TransactionAmount    = '#valdocument#',
										   ExchangeRate         = '#excjournal#', 
										   AmountCredit         = '#valjournal#',
										   AmountDebit          = '0',
										   ExchangeRateBase     = '#excbase#', 
										   AmountBaseCredit     = '#val#',
										   AmountBaseDebit      = '0'	
									WHERE  TransactionLineId    = '#TransactionLineId#'				
									AND    TransactionSerialNo  = '2'	
								
								</cfquery>								
								
								<!--- ------------------------------------------------------------------------------------- --->
								<!--- 8/2/2016 : attention we are not yet adjusting the posted tax here as part of the sale --->	
						
							</cfloop>		
					
					</cfif>		
					
				</cfif> 
				
				</cfloop>

				<cfif getLines.recordcount neq 0>
					<cfset session.status = (getLines.currentrow/getLines.recordcount) * finalStatus> 
				</cfif>
				
			</cfloop>	
												
	</cffunction>	
		
	<!--- ---------------------------------------------- --->
	<!--- ----- 2. obtain issuance valuation----- ------ --->
	<!--- ---------------------------------------------- --->
		
	<cffunction name="getItemValuation"
         access="remote"
         returntype="any"
         displayname="Set the valuation of a transaction">
				
		<cfargument name="DataSource"          default="AppsMaterials">	
		<cfargument name="TransactionQuantity" default="">	
		<cfargument name="TransactionDate"     default="">	
		<cfargument name="Mission"             default="">	
		<cfargument name="TransactionId"       default="">	
		<cfargument name="Warehouse"           default="">	
		<cfargument name="Location"            default="">
		<cfargument name="TransactionLot"      default="">	
		<cfargument name="TransactionUoM"      default="">	
		<cfargument name="ItemNo"              default="">	
		<cfargument name="TransactionIdOrigin" default="">	
		<cfargument name="WorkOrderid"         default="">
		
		<!--- precision --->		
		<cfset precision = "5">
		
		<cfset corr = "1">		
		<cfloop index="itm" from="1" to="#precision#">
			<cfset corr = "#corr#0">
		</cfloop>
					
		<!--- each incoming transaction will be sourced for outgoing stuff 
		
		so if we received 100 in transaction X and 100 in transaction Y and we distribute 200, 
		
		this table will contain the distribution details as to where the 200 come from, where as in
		item transaction we just have a total of 200 for outgoing
		
		--->
		
		<!--- book transaction as FIFO, after the distribution 
		transaction has been recorded as booked, so we know we have stock for the passed
		transaction quantity here upfront already!!!  --->
		
		<cfset reqqty = "#TransactionQuantity*-1#">		
		
		<cfset val = 0>
		
		<cfset dateValue = "">
		<CF_DateConvert Value="#TransactionDate#">
		<cfset dte = dateValue>

		<cfloop condition="#reqqty# gt 0">
		
			<cfquery name="ItemVal" 
			   datasource="#DataSource#" 
			   username="#SESSION.login#" 
			   password="#SESSION.dbpw#">
			   SELECT    *
			   FROM     Materials.dbo.Item
			   WHERE    ItemNo = '#itemNo#'	  
			</cfquery>
					
			<cfif ItemVal.ValuationCode eq "LIFO">
			   <cfset dir = "DESC">
			<cfelseif ItemVal.ValuationCode eq "FIFO">
			    <cfset dir = "ASC">
			<cfelse>	
			    <!--- Manual --->
				<cfset dir = "ASC">
			</cfif>	
			
			<!--- get all the transactions for a location/item/upm/lot // get an individual transaction
			 that are a positive and have not been fully sourced yet --->
			
			<cfquery name="Valuation" 
			   datasource="#DataSource#" 
			   username="#SESSION.login#" 
			   password="#SESSION.dbpw#">			   
			  						    					   
					   SELECT     T.TransactionId as TraId, 
					              T.TransactionQuantity, 
								  T.TransactionCostPrice,
								  T.TransactionValue,
								  T.ReceiptPrice,
								  
								  <!--- ------------------------------------------------------ --->
								  <!--- determine how much has been source of each transaction --->
								  <!--- ------------------------------------------------------ --->									 							 				  
								 									  
								  ( SELECT ISNULL(SUM(TransactionQuantity),0)
								    FROM   Materials.dbo.ItemTransactionValuation
									WHERE  TransactionId = T.TransactionId
								  ) as Processed, 	
								 								 								 
								  T.TransactionDate,
								  T.Created
					   FROM       Materials.dbo.ItemTransaction T
								  
					   <cfif TransactionIdOrigin eq "">			  
					   
						   WHERE     T.Warehouse       = '#Warehouse#' 
						   AND       T.Location        = '#Location#'	   
						   AND       T.TransactionQuantity > 0  <!--- sourcing of stock --->
						   AND       T.ItemNo          = '#ItemNo#'
						   AND       T.TransactionUoM  = '#TransactionUoM#' 	  		   
						   AND       T.TransactionLot  = '#TransactionLot#'
						   
						   <cfif ItemVal.ValuationCode eq "LIFO">
						   AND       T.TransactionDate < #dte#
						   <cfelse>
						   <!--- to prevent items recently received are messing up prior stock --->
						   AND       T.TransactionDate < #dte#
						   </cfif>			   
						   <!--- ----------------------------------------------------------------------------------------- --->
						   <!--- here we add a mechanism to check for the same workorder first, nothing found check next-- --->
						   <!--- ----------------------------------------------------------------------------------------- --->
						   
						   <cfif workorderid neq "">
						   AND	     T.WorkOrderId      = '#WorkOrderId#'
						   </cfif>	 
						
					   <cfelse>
					   
					   	  <!---  individual tracking mode added 18/11/2013 : Hicosa  --->							  
					      WHERE      T.TransactionId    = '#TransactionIdOrigin#'
					   
					   </cfif>	 					   
													   
				   GROUP BY   T.TransactionId, 
					          T.TransactionQuantity, 
							  T.TransactionCostPrice,
							  T.TransactionValue,
							  T.ParentTransactionId,
							  T.ReceiptPrice,	
							  T.TransactionDate,	
							  T.Created		
							  
					HAVING T.TransactionQuantity > (SELECT ISNULL(SUM(TransactionQuantity),0)
								    				   FROM   Materials.dbo.ItemTransactionValuation
													   WHERE  TransactionId = T.TransactionId)		  					   
			   
			   	   ORDER BY T.TransactionDate #dir#, 
				            T.Created #dir#,
							T.ParentTransactionId  
			</cfquery>
						
			<!--- ------------------------------------------------------------------------------------------- --->
		    <!--- here we added a mechanism to check for the workorder if nothing is found we check for total --->
			<!--- ------------------------------------------------------------------------------------------- --->
			
			<cfif Valuation.recordcount eq "0" and TransactionIdOrigin eq "">  
			
			  <!--- 18/11/2013 keep in mind that a sum transacion always return 1 record at least so it has to be Valuation.Processed --->
			
			    <cfquery name="Valuation" 
			     datasource="#DataSource#" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
				 
			 		   SELECT     T.TransactionId as TraId, 
					              T.TransactionQuantity, 
								  T.TransactionCostPrice,
								  T.TransactionValue,
								  T.ReceiptPrice,
								  
								  <!--- ------------------------------------------------------ --->
								  <!--- determine how much has been source of each transaction --->
								  <!--- ------------------------------------------------------ --->									 							 				  
								 									  
								  ( SELECT ISNULL(SUM(TransactionQuantity),0)
								    FROM   Materials.dbo.ItemTransactionValuation
									WHERE  TransactionId = T.TransactionId
								  ) as Processed, 	
								 								 								 
								  T.TransactionDate,
								  T.Created
					   FROM       Materials.dbo.ItemTransaction T
											   
					   WHERE      T.Warehouse       = '#Warehouse#' 
					   <!---  AND       T.Location        = '#Location#'	     --->
					   AND        T.TransactionQuantity > 0  <!--- sourcing of stock --->
					   AND        T.ItemNo          = '#ItemNo#'
					   AND        T.TransactionUoM  = '#TransactionUoM#' 						
					   <!---  AND       T.TransactionLot  = '#TransactionLot#'   --->						   
					  <cfif ItemVal.ValuationCode eq "LIFO">
					   AND       T.TransactionDate < #dte#
				      <cfelse>
					   <!--- to prevent items recently received are messing up prior stock --->
					   AND       T.TransactionDate < #dte#
					  </cfif>		   
					
					   <!--- ----------------------------------------------------------------------------------------- --->
					   <!--- here we add a mechanism to check for the same workorder first, nothing found check next-- --->
					   <!--- ----------------------------------------------------------------------------------------- --->
						   
					   <cfif workorderid neq "">
					   AND	      T.WorkOrderId      = '#WorkOrderId#'
					   </cfif>					     					 					   
													   
				   GROUP BY   T.TransactionId, 
					          T.TransactionQuantity, 
							  T.TransactionCostPrice,
							  T.TransactionValue,
							  T.ParentTransactionId,
							  T.ReceiptPrice,	
							  T.TransactionDate,	
							  T.Created		
							  
					HAVING T.TransactionQuantity > (SELECT ISNULL(SUM(TransactionQuantity),0)
								    				   FROM   Materials.dbo.ItemTransactionValuation
													   WHERE  TransactionId = T.TransactionId)		  					   
			   
			   	   ORDER BY T.TransactionDate #dir#, 
				            T.Created #dir#, 
							T.ParentTransactionId  									 
			   
			   	 </cfquery>
				
			</cfif>
						
			<cfif Valuation.recordcount eq "0" and TransactionIdOrigin eq "" and WorkorderId neq "">  
			
			  <!--- 18/11/2013 keep in mind that a sum transacion always return 1 record at least so it has to be Valuation.Processed --->
			
			    <cfquery name="Valuation" 
			     datasource="#DataSource#" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
				 
			 		   SELECT     T.TransactionId as TraId, 
					              T.TransactionQuantity, 
								  T.TransactionCostPrice,
								  T.TransactionValue,
								  T.ReceiptPrice,
								  
								  <!--- ------------------------------------------------------ --->
								  <!--- determine how much has been source of each transaction --->
								  <!--- ------------------------------------------------------ --->									 							 				  
								 									  
								  ( SELECT ISNULL(SUM(TransactionQuantity),0)
								    FROM   Materials.dbo.ItemTransactionValuation
									WHERE  TransactionId = T.TransactionId
								  ) as Processed, 	
								 								 								 
								  T.TransactionDate,
								  T.Created
					   FROM       Materials.dbo.ItemTransaction T
						
					   WHERE      T.Warehouse       = '#Warehouse#' 					   
					   <!---  AND       T.Location        = '#Location#'        --->
					   AND        T.TransactionQuantity > 0  <!--- sourcing of stock --->
					   AND        T.ItemNo          = '#ItemNo#'
					   AND        T.TransactionUoM  = '#TransactionUoM#' 	
					   <!---  AND       T.TransactionLot  = '#TransactionLot#'  --->						   
					  <cfif ItemVal.ValuationCode eq "LIFO">
					   AND       T.TransactionDate < #dte#
					  <cfelse>
					   <!---  TO prevent items recently received are messing up prior stock --->
					   AND       T.TransactionDate < #dte#
					   </cfif>						  
					   <!--- also the workorder id is removed now --->						   
					   <!---  AND	     T.WorkOrderId      = '#WorkOrderId#'   --->				   						  					 					   
													   
				       GROUP BY   T.TransactionId, 
					              T.TransactionQuantity, 
							      T.TransactionCostPrice,
								  T.TransactionValue,
							      T.ReceiptPrice,	
							      T.TransactionDate,	
								  T.ParentTransactionId,
							      T.Created		
							  
					   HAVING     T.TransactionQuantity > (SELECT ISNULL(SUM(TransactionQuantity),0)
								        				   FROM   Materials.dbo.ItemTransactionValuation
										    			   WHERE  TransactionId = T.TransactionId)		  					   
			   
			   	       ORDER BY   T.TransactionDate #dir# , 
					              T.Created #dir# ,
								  T.ParentTransactionId 									 
			   
			   	 </cfquery>
				 
			</cfif>	 
			
			 <!--- -------------------------------------------6/16/2017----------------------------------------------- --->
			 <!--- final a added option to check for late receipts to this warehouse to prevent taking std cost price  --->
			 <!--- --------------------------------------------------------------------------------------------------- --->
			
			<cfif Valuation.recordcount eq "0" and TransactionIdOrigin eq ""> 
								 				 				 				 
					  <cfquery name="Valuation" 
				     datasource="#DataSource#" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
					 
				 		   SELECT     T.TransactionId as TraId, 
						              T.TransactionQuantity, 
									  T.TransactionCostPrice,
									  T.TransactionValue,
									  T.ReceiptPrice,
									  
									  <!--- ------------------------------------------------------ --->
									  <!--- determine how much has been source of each transaction --->
									  <!--- ------------------------------------------------------ --->									 							 				  
									 									  
									  ( SELECT ISNULL(SUM(TransactionQuantity),0)
									    FROM   Materials.dbo.ItemTransactionValuation
										WHERE  TransactionId = T.TransactionId
									  ) as Processed, 	
									 								 								 
									  T.TransactionDate,
									  T.Created
						   FROM       Materials.dbo.ItemTransaction T
							
						   WHERE      T.Warehouse       = '#Warehouse#' 					   
						   <!---  AND       T.Location        = '#Location#'        --->
						   AND        T.TransactionQuantity > 0  <!--- sourcing of stock --->
						   AND        T.ItemNo          = '#ItemNo#'
						   AND        T.TransactionUoM  = '#TransactionUoM#' 	
						   <!---  AND       T.TransactionLot  = '#TransactionLot#'  --->	
						   
						   <!--- remove a rely on delayed receipt
						   					   
						   <cfif ItemVal.ValuationCode eq "LIFO">
						   AND       T.TransactionDate <= #dte#
						   <cfelse>
						   <!---  TO prevent items recently received are messing up prior stock --->
						   AND       T.TransactionDate <= #dte#
						   </cfif>		
						   
						   --->
						   
						   <!--- 2016/6/19 : ADJUSTED we take a receipt transaction that may fall later in time
						   but we make sure this is not a transction which is related to the transaction to be sourced
						   in case of 6 and 8 to prevent internal links --->
						  						   
						   AND       T.TransactionType IN ('0','1','5','9') <!--- production, receipt, difference, initial stock, transfer --->
						   						   
						   <cfif ItemVal.ValuationCode eq "LIFO">
						   AND       T.TransactionDate >= #dte#
						   <cfelse>
						   <!---  TO prevent items recently received are messing up prior stock --->
						   AND       T.TransactionDate >= #dte#
						   </cfif>		
						   						   				  
						   <!--- also the workorder id is removed now --->						   
						   <!---  AND	     T.WorkOrderId      = '#WorkOrderId#'   --->				   						  					 					   
														   
					       GROUP BY   T.TransactionId, 
						              T.TransactionQuantity, 
								      T.TransactionCostPrice,
									  T.TransactionValue,
									  T.ParentTransactionId,
								      T.ReceiptPrice,	
								      T.TransactionDate,	
								      T.Created		
						
						   <!--- transaction is not fully sourced and can be used --->		  
						   HAVING     T.TransactionQuantity > (SELECT ISNULL(SUM(TransactionQuantity),0)
									        				   FROM   Materials.dbo.ItemTransactionValuation
											    			   WHERE  TransactionId = T.TransactionId)		  					   
				   
				   	       ORDER BY   T.TransactionDate #dir#, 
						              T.Created #dir# ,
									  T.ParentTransactionId 									 
				   
				   	 </cfquery>
									
			</cfif>			
			
			<cfif Valuation.recordcount eq "0" and TransactionIdOrigin eq ""> 
			
			
				 <cfquery name="Valuation" 
				     datasource="#DataSource#" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
					 
				 		   SELECT     T.TransactionId as TraId, 
						              T.TransactionQuantity, 
									  T.TransactionCostPrice,
									  T.TransactionValue,
									  T.ReceiptPrice,
									  
									  <!--- ------------------------------------------------------ --->
									  <!--- determine how much has been source of each transaction --->
									  <!--- ------------------------------------------------------ --->									 							 				  
									 									  
									  ( SELECT ISNULL(SUM(TransactionQuantity),0)
									    FROM   Materials.dbo.ItemTransactionValuation
										WHERE  TransactionId = T.TransactionId
									  ) as Processed, 	
									 								 								 
									  T.TransactionDate,
									  T.Created
						   FROM       Materials.dbo.ItemTransaction T
							
						   WHERE      T.Warehouse       = '#Warehouse#' 					   
						   <!---  AND       T.Location        = '#Location#'        --->
						   AND        T.TransactionQuantity > 0  <!--- sourcing of stock --->
						   AND        T.ItemNo          = '#ItemNo#'
						   AND        T.TransactionUoM  = '#TransactionUoM#' 	
						   <!---  AND       T.TransactionLot  = '#TransactionLot#'  --->	
						   
						   <!--- remove a rely on delayed receipt
						   					   
						   <cfif ItemVal.ValuationCode eq "LIFO">
						   AND       T.TransactionDate <= #dte#
						   <cfelse>
						   <!---  TO prevent items recently received are messing up prior stock --->
						   AND       T.TransactionDate <= #dte#
						   </cfif>		
						   
						   --->
						   
						   <!--- 2016/6/19 : ADJUSTED we take a receipt transaction that may fall later in time
						   but we make sure this is not a transction which is related to the transaction to be sourced
						   in case of 6 and 8 to prevent internal links --->
						  						   
						   AND       T.TransactionType IN ('6','8') <!--- production, receipt, difference, initial stock, transfer --->
						   						   
						   <cfif ItemVal.ValuationCode eq "LIFO">
						   AND       T.TransactionDate >= #dte#
						   <cfelse>
						   <!---  TO prevent items recently received are messing up prior stock --->
						   AND       T.TransactionDate >= #dte#
						   </cfif>		
						   						   				  
						   <!--- also the workorder id is removed now --->						   
						   <!---  AND	     T.WorkOrderId      = '#WorkOrderId#'   --->				   						  					 					   
														   
					       GROUP BY   T.TransactionId, 
						              T.TransactionQuantity, 
								      T.TransactionCostPrice,
									  T.TransactionValue,
									  T.ParentTransactionId,
								      T.ReceiptPrice,	
								      T.TransactionDate,	
								      T.Created		
						
						   <!--- transaction is not fully sourced and can be used --->		  
						   HAVING     T.TransactionQuantity > (SELECT ISNULL(SUM(TransactionQuantity),0)
									        				   FROM   Materials.dbo.ItemTransactionValuation
											    			   WHERE  TransactionId = T.TransactionId)		  					   
				   
				   	       ORDER BY   T.TransactionDate #dir#, 
						              T.Created #dir# ,
									  T.ParentTransactionId 									 
				   
				   	 </cfquery>
			
			
			</cfif>
					
			<!--- ---------------------------------------------------- --->
			<!--- special provision if there are No lines to draw from --->
			<!--- ---------------------------------------------------- --->
			
			<cfif Valuation.recordcount eq 0>  <!--- 18/11/2013 keep in mind that a sum transacion
			                                       always return 1 record at least --->
															
					<cfset tra    = reqqty>
					
					<!--- this will finish the loop --->
					<cfset reqqty = 0>	
					
					<!--- ---------------------------------------------------------- --->
					<!--- special case for negative stock it will source from itself --->
					<!--- ATTENTION ------------------------------------------------ --->
					<!--- was adjusted 16/6, to take the last price if this item/uom --->
					<!--- had already some valuations instead ---------------------- --->
					<!--- driven by complains of FOMTEX on the valuation ----------- --->
										
					<cfquery name="Last" 
					   datasource="#DataSource#" 
					   username="#SESSION.login#" 
					   password="#SESSION.dbpw#">
					   SELECT    TOP 1 *
					   FROM      Materials.dbo.ItemTransaction
					   WHERE     ItemNo  = '#itemNo#'	 
					   AND       TransactionUoM     = '#TransactionUoM#' 
					   AND       Mission = '#Mission#'
					   AND       TransactionDate < (SELECT TransactionDate 
					                                FROM   Materials.dbo.ItemTransaction
													WHERE  TransactionId = '#TransactionId#')
					   ORDER BY TransactionDate DESC					   
					</cfquery>
					
					<cfif Last.recordcount gte "1">
					
						<cfset pr = Last.TransactionCostPrice>
					
					<cfelse>													
														
					    <!--- get a price --->
						
						<cfquery name="UoM" 
						   datasource="#DataSource#" 
						   username="#SESSION.login#" 
						   password="#SESSION.dbpw#">
						   SELECT    *
						   FROM      Materials.dbo.ItemUoMMission
						   WHERE     ItemNo  = '#itemNo#'	 
						   AND       UoM     = '#TransactionUoM#' 
						   AND       Mission = '#Mission#'
						</cfquery>
						
						<cfif UoM.recordcount eq "0">
						
						    <cfquery name="UoM" 
							   datasource="#DataSource#" 
							   username="#SESSION.login#" 
							   password="#SESSION.dbpw#">
							   SELECT    *
							   FROM     Materials.dbo.ItemUoM
							   WHERE    ItemNo = '#ItemNo#'	 
							   AND      UoM    = '#TransactionUoM#' 
							</cfquery>
						
						</cfif>
					
						<cfset pr = UoM.StandardCost>
					
					</cfif>
					
					<cfset traval = round(tra*pr*corr)/corr>
										
					<cfquery name="Insert" 
				      datasource="#DataSource#" 
				      username="#SESSION.login#" 
				      password="#SESSION.dbpw#">		
					 					  
					   INSERT INTO Materials.dbo.ItemTransactionValuation
							   (TransactionId, 
							    SerialNo,
								DistributionTransactionId,
								TransactionQuantity,
								TransactionCostPrice,
								TransactionCostPriceValue,
								TransactionPrice,
								TransactionPriceValue)
					   VALUES
						   ('#transactionId#',
						    '1',
							'#transactionId#',
							'#tra#',
							'#pr#',
							'#traval#',
							'#pr#',
							'#tra*pr#') 			
					</cfquery>
							
			<cfelse>	
					
				<!--- define the sourcing records for this transaction --->
							
				<cfloop query = "Valuation">		
				
					<cfif Processed eq "0" or Processed eq "">
						<cfset bal = Valuation.TransactionQuantity>
					<cfelse>
					    <cfset bal = Valuation.TransactionQuantity-Valuation.Processed>	
					</cfif>
					
					<cfif reqqty lte bal>
						<cfset tra    = reqqty>
						<cfset reqqty = 0>
					<cfelse>
						<cfset tra    =  bal>		
						<cfset reqqty = reqqty-bal>
					</cfif>
					
														
					<!--- create valuation transaction --->					
					
				    <cfquery name="Check" 
				      datasource="#DataSource#" 
				      username="#SESSION.login#" 
				      password="#SESSION.dbpw#">
					     SELECT     MAX(SerialNo) as SerialNo
			    		 FROM       Materials.dbo.ItemTransactionValuation 
					     WHERE      TransactionId = '#TraId#'
				    </cfquery>
					
					<cfif check.serialNo eq "">
					     <cfset No = 1>
					<cfelse>
					     <cfset No = check.serialNo+1>  
					</cfif>
					
					<cfif ItemVal.ValuationCode eq "Manual" or ItemVal.ItemClass eq "Service">
					
						<cfquery name="UoM" 
						   datasource="#DataSource#" 
						   username="#SESSION.login#" 
						   password="#SESSION.dbpw#">
						   SELECT    *
						   FROM     Materials.dbo.ItemUoMMission
						   WHERE    ItemNo  = '#ItemNo#'	 
						   AND      UoM     = '#TransactionUoM#' 
						   AND      Mission = '#Mission#'
						</cfquery>
						
						<cfif UoM.recordcount eq "1">
					
							<cfset pr = UoM.StandardCost>
						
						<cfelse>
						
							<cfquery name="UoM" 
							   datasource="#DataSource#" 
							   username="#SESSION.login#" 
							   password="#SESSION.dbpw#">
							   SELECT    *
							   FROM     Materials.dbo.ItemUoM
							   WHERE    ItemNo = '#ItemNo#'	 
							   AND      UoM    = '#TransactionUoM#' 				   
							</cfquery>
						
							<cfset pr = UoM.StandardCost>
						
						</cfif>
															
					<cfelseif ItemVal.ValuationCode eq "LIFO" or ItemVal.ValuationCode eq "FIFO">
					
					    <!--- the main one --->
						<cfset pr = round((TransactionValue/Valuation.TransactionQuantity)*corr)/corr>	
														
											
					<cfelseif ItemVal.ValuationCode eq "Average">	
					
						<!--- pending Hanno --->
					
						<cfquery name="UoM" 
						   datasource="#DataSource#" 
						   username="#SESSION.login#" 
						   password="#SESSION.dbpw#">
						   SELECT    *
						   FROM     Materials.dbo.ItemUoM
						   WHERE    ItemNo = '#ItemNo#'	 
						   AND      UoM    = '#TransactionUoM#' 
						</cfquery>
					
						<cfset pr = UoM.StandardCost>
					
					<!--- pending Hanno 
					
					<cfelseif ItemVal.ValuationCode eq "Last">	
												
						<cfquery name="UoM" 
						   datasource="#DataSource#" 
						   username="#SESSION.login#" 
						   password="#SESSION.dbpw#">
						   SELECT    *
						   FROM     Materials.dbo.ItemUoM
						   WHERE    ItemNo = '#itemNo#'	 
						   AND      UoM  = '#TransactionUoM#' 
						</cfquery>
					
						<cfset pr = UoM.StandardCost>
					
					</cfif>
					
					--->
					
					</cfif>
					
					<!--- record how the original receiving transaction is then being slowly distributed into portions
					based on the valuation mode --->
					
																	
					<cfif tra neq "0">
					
						<cfset traval = round(tra*pr*corr)/corr>
					
					    <cfif ReceiptPrice eq "">
							
							<cfquery name="Insert" 
						      datasource="#DataSource#" 
						      username="#SESSION.login#" 
						      password="#SESSION.dbpw#">		
							   INSERT INTO Materials.dbo.ItemTransactionValuation
								   (TransactionId, 
								    SerialNo,
									DistributionTransactionId,
									TransactionQuantity,
									TransactionCostPrice,
									TransactionCostPriceValue,
									TransactionPrice,
									TransactionPriceValue)
							   VALUES
								   ('#TraId#',
								    '#No#',
									'#TransactionId#',
									'#tra#',
									'#pr#', 
									'#traval#',
									'#pr#',
									'#tra*pr#') 		
														
							</cfquery>
						
						<cfelse>
									
							<cfquery name="Insert" 
						      datasource="#DataSource#" 
						      username="#SESSION.login#" 
						      password="#SESSION.dbpw#">						
							   INSERT INTO Materials.dbo.ItemTransactionValuation
									   (TransactionId, 
									    SerialNo,
										DistributionTransactionId,
										TransactionQuantity,
										TransactionCostPrice,
										TransactionCostPriceValue,
										TransactionPrice,
										TransactionPriceValue)
							   VALUES  ('#TraId#',
									    '#No#',
										'#TransactionId#',
										'#tra#',
										'#pr#',
										'#traval#',
										'#ReceiptPrice#',
										'#tra*ReceiptPrice#') 		
																										
							</cfquery>
						
						</cfif>
					
					</cfif>
													
				</cfloop>
				
			</cfif>	
		
		</cfloop>   
		
	</cffunction>		
		
	<!--- ---------------------------------------------- --->
	<!--- ----- 3. correct item receipt valuation ------ --->
	<!--- ---------------------------------------------- --->
		
	<cffunction name="correctItemValuation"
        access="public"
        returntype="any"
        displayname="26/7/2016 adjust the price of a stock receipt/production transaction and related corrections to issuance">
		
		<cfargument name="ReceiptId"            type="string"   required="false"   default="">	
		<cfargument name="TraId"                type="string"   required="false"   default="">	
		
		
		<cfargument name="ReceiptCurrency"      type="string"   required="true">		
		<cfargument name="ReceiptPrice"         type="numeric"  required="true"   default="0">
		
		<cfargument name="ReceiptCostCurrency"  type="string"   required="true"   default="#ReceiptCurrency#">	
		<cfargument name="ReceiptCostPrice"     type="numeric"  required="true"   default="0">
		
		<cfargument name="GLCurrency"           type="string"   required="true"   default="#ReceiptCurrency#">			
		
		<cfif receiptid neq "">
		
			<!--- in case of detailline 
			through purchaselinereceiptdetail a single receiptid can have several itemtransaction lines 
			then we go through each receipt line for the quantities
			--->
		
			<cfquery name="Receipt" 
			   datasource="AppsMaterials" 
			   username="#SESSION.login#" 
			   password="#SESSION.dbpw#">
			   SELECT  *
			   FROM    Materials.dbo.ItemTransaction 
			   WHERE   ReceiptId = '#Receiptid#'		   	   
			</cfquery>
		
		<cfelse>
		
			<cfquery name="Receipts" 
			   datasource="AppsMaterials" 
			   username="#SESSION.login#" 
			   password="#SESSION.dbpw#">
			   SELECT  *
			   FROM    Materials.dbo.ItemTransaction 
			   WHERE   TransactionId = '#TraId#'		   	   
			</cfquery>
				
		</cfif>
				
		<cftransaction>
		
			<cfloop query="Receipt">			
			
				<!--- update receipt --->
				
				<cfif receiptid neq "">
				
					<cfquery name="getReceipt" 
					   datasource="AppsMaterials" 
					   username="#SESSION.login#" 
					   password="#SESSION.dbpw#">
					   SELECT  *
					   FROM    Purchase.dbo.PurchaseLineReceipt
					   WHERE   ReceiptId = '#Receiptid#'		   	   
					</cfquery>	
					
					<cfset tradte = dateFormat(getReceipt.DeliveryDate, CLIENT.DateFormatShow)>
					
					<!--- quantity is the new quantityfrom the transaction this can be the subline --->			
					<cfset qty   = TransactionQuantity>	
					
					<!--- ATTENTION now we check if the receipt might have changed but ONLY if 
					   the receipt has just one record and no detail, then we allow for it ONLY --->
					
					<cfif receipt.recordcount eq "1">
					
						<cfif getReceipt.ReceiptWarehouse gt qty>
						
							<cfset qty = getReceipt.ReceiptWarehouse>	
						
						</cfif>
					
					</cfif>
																			
					<!--- cost and price in receipt currency --->
					<cfset documentcurrency     =  ReceiptCurrency>
					<cfset documentcostvalue    =  round((qty * receiptCostPrice)*100)/100>
					<cfset documentpricevalue   =  round((qty * receiptPrice)*100)/100>
															
					<cfset diff = documentpricevalue - documentcostvalue>						
																					
					<cf_exchangeRate datasource = "appsMaterials"
							EffectiveDate       = "#tradte#"
					        CurrencyFrom        = "#ReceiptCurrency#"
							CurrencyTo          = "#GLCurrency#"> 			
					
					<!--- cost and price in JOURNAL currency --->
					<cfset journalexc           =  exc>	
					<cfset journalcostvalue	    =  round((documentcostvalue/exc)*100)/100>				 
					<cfset journalpricevalue    =  round((documentpricevalue/exc)*100)/100>
					<cfset diffjournal          =  round((diff/exc)*100)/100>
					
					<cf_exchangeRate datasource = "appsMaterials"
							EffectiveDate       = "#tradte#"
					        CurrencyFrom        = "#ReceiptCostCurrency#"
							CurrencyTo          = "#application.baseCurrency#"> 									
										
					<!--- cost and price BASE currency --->		
					<cfset stockcostexc         =  exc>			
					<cfset stockcostvalue       =  round((documentcostvalue/exc)*100)/100>																				
					<cfset stockcostprice       =  round((stockcostvalue/qty)*10000)/10000>						
					<cfset stockpricevalue      =  round((documentpricevalue/exc)*100)/100>
					<cfset stockprice           =  round((stockpricevalue/qty)*10000)/10000>	
					
					<cfset diffstock            =  round((diff/exc)*100)/100>																		
				
				<cfelse>
								
					<!--- production passing --->				
				
				</cfif>		
					
								
				<cfquery name="resetReceiptLine" 
				   datasource="AppsMaterials" 
				   username="#SESSION.login#" 
				   password="#SESSION.dbpw#">				  
					   UPDATE Materials.dbo.ItemTransaction
					   SET    TransactionQuantity       =  '#qty#', 
					   		  TransactionCostPrice      =  '#stockcostprice#', 
					          TransactionValue          =  '#stockcostvalue#',
							  ReceiptCostPrice          =  '#receiptCostPrice#', <!--- currency of the receipt --->
							  ReceiptPrice              =  '#receiptPrice#'							 
					   WHERE  TransactionId             =  '#transactionid#'		 
				</cfquery>		
							
				<!--- correct the posting header --->
				
				<cfquery name="getPosting" 
				   datasource="AppsMaterials" 
				   username="#SESSION.login#" 
				   password="#SESSION.dbpw#">
				       SELECT * 
					   FROM   Accounting.dbo.TransactionHeader					 				 
					   WHERE  ReferenceId = '#transactionid#'		  	   			   
				</cfquery>
				
				<!--- also include the exchange rate from the header --->
				
				<cfquery name="resetReceiptLedger" 
				   datasource="AppsMaterials" 
				   username="#SESSION.login#" 
				   password="#SESSION.dbpw#">
				   
				       UPDATE Accounting.dbo.TransactionHeader
					   SET    DocumentAmount   =  '#documentpricevalue#',
					          ExchangeRate     =  '#journalexc#',
					          Amount           =  '#journalpricevalue#'							 					 
					   WHERE  Journal          = '#getPosting.Journal#'
					   AND    JournalSerialNo  = '#getPosting.JournalSerialNo#'			
					   		  	  	   			   
				</cfquery>   	
				
				<!--- correction the transaction posting lines --->
				
				<!--- 1. stock, 2 purchases and 3 is differences --->
								
				<cfquery name="resetReceiptLedger1" 
				   datasource="AppsMaterials" 
				   username="#SESSION.login#" 
				   password="#SESSION.dbpw#">
				   
				       UPDATE Accounting.dbo.TransactionLine
					   
					   SET    TransactionAmount   =  '#documentcostvalue#',
					   		  ExchangeRate        =  '#journalexc#',	
					          AmountDebit         =  '#journalcostvalue#',	
							  ExchangeRateBase    =  '#stockcostexc#',
							  AmountBaseDebit     =  '#stockcostvalue#'
							  
					   WHERE  Journal             = '#getPosting.Journal#'
					   AND    JournalSerialNo     = '#getPosting.JournalSerialNo#'		
					   AND    TransactionSerialNo = '1'		
					     						 					 					    	   			   
				</cfquery>   	
				
				<cfquery name="resetReceiptLedger2" 
				   datasource="AppsMaterials" 
				   username="#SESSION.login#" 
				   password="#SESSION.dbpw#">
				   
				       UPDATE Accounting.dbo.TransactionLine
					   
					   SET    TransactionAmount   =  '#documentpricevalue#',
					   		  ExchangeRate        =  '#journalexc#',
					          AmountCredit        =  '#journalpricevalue#',
							  ExchangeRateBase    =  '#stockcostexc#',	
							  AmountBaseCredit    =  '#stockpricevalue#'	
							  				  
					   WHERE  Journal             = '#getPosting.Journal#'
					   AND    JournalSerialNo     = '#getPosting.JournalSerialNo#'		
					   AND    TransactionSerialNo = '2'		 
					    						 					 					    	   			   
				</cfquery>  			
				
				<cfquery name="resetReceiptLedger3" 
				   datasource="AppsMaterials" 
				   username="#SESSION.login#" 
				   password="#SESSION.dbpw#">
				   
				       UPDATE Accounting.dbo.TransactionLine	
					   					   				   
					   <cfif diff gte "0">
					   SET    TransactionAmount    =  '#diff#',
					   		  ExchangeRate         =  '#journalexc#',
							  AmountCredit         =  '0',
					          AmountDebit          =  '#diffJournal#',	
							  ExchangeRateBase     =  '#stockcostexc#',	
							  AmountBaseCredit     =  '0',
							  AmountBaseDebit      =  '#diffStock#'
					   <cfelse>
					   SET    TransactionAmount    =  '#diff#',
							  ExchangeRate         =  '#journalexc#',
					          AmountCredit         =  '#diffJournal#',	
							  AmountDebit          =  '0',
							  ExchangeRateBase     =  '#stockcostexc#',	
							  AmountBaseCredit     =  '#diffStock#',
							  AmountBaseDebit      =  '0'
					   </cfif>		
					   					   					   
					   WHERE  Journal         = '#getPosting.Journal#'
					   AND    JournalSerialNo = '#getPosting.JournalSerialNo#'		
					   AND    TransactionSerialNo = '3'			
					   				     						 					 					    	   			   
				</cfquery>   	 				
																
				<!--- ------------------------- --->					
			
				<cfquery name="getIssuances" 
				   datasource="AppsMaterials" 
				   username="#SESSION.login#" 
				   password="#SESSION.dbpw#">
				   SELECT  TransactionId, DistributionTransactionId
				   FROM    Materials.dbo.ItemTransactionValuation 
				   WHERE   TransactionId = '#transactionid#'		   	   
				</cfquery>
			
			    <!--- we reset any values from this receipt found in the valuation --->
			
				<cfquery name="resetIssues" 
				   datasource="AppsMaterials" 
				   username="#SESSION.login#" 
				   password="#SESSION.dbpw#">
					   UPDATE Materials.dbo.ItemTransactionValuation
					   SET    TransactionCostPrice      =  '#stockcostprice#',
					          TransactionCostPriceValue =  '#stockcostprice#'*TransactionQuantity,
							  TransactionPrice          =  '#stockPrice#', 
							  TransactionPriceValue	    =  '#stockPrice#'*TransactionQuantity 
					   WHERE  TransactionId = '#transactionid#'		  	   
				</cfquery>
											
				<cfloop query="getIssuances">
				
					<!--- obtain all the values found for this distribution against any source
					that is involved in this receipt  --->
					
					<cfquery name="getValue" 
					   datasource="AppsMaterials" 
					   username="#SESSION.login#" 
					   password="#SESSION.dbpw#">
					   SELECT    SUM(TransactionQuantity)       AS Quantity, 
					             SUM(TransactionCostPriceValue) AS Value
				       FROM      Materials.dbo.ItemTransactionValuation
					   WHERE     DistributionTransactionId = '#DistributionTransactionId#' 
					   
					</cfquery>
					
					<!--- all adjustments are in base currency --->
					
					<cfset val = round(getValue.Value*100)/100>
					<cfset prc = round((getValue.Value/getValue.Quantity)*10000)/10000>			
					
					<cfquery name="Update" 
					   datasource="AppsMaterials" 
					   username="#SESSION.login#" 
					   password="#SESSION.dbpw#">		
					      				  				   
						   UPDATE   Materials.dbo.ItemTransaction						   
						   SET      TransactionCostPrice = '#prc#',
						            TransactionValue     = #val*-1#
						   WHERE    TransactionId        = '#DistributionTransactionId#'   
						   AND      TransactionQuantity < 0 
					   		   
					</cfquery>  
					 
					<cfquery name="getGL"
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT * 
						FROM   Accounting.dbo.TransactionHeader			
						WHERE  ReferenceId          = '#DistributionTransactionId#'
					</cfquery>
					
					<cfquery name="setGLTransaction"
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						UPDATE Accounting.dbo.TransactionHeader
						SET    DocumentAmount       = '#val#',
							   Amount               = '#val#'				
						WHERE  ReferenceId          = '#DistributionTransactionId#'
					</cfquery>
					
					<!--- get the 2 lines of the distribution --->
					
					<cfquery name="getGLLines"
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT * 
						FROM   Accounting.dbo.TransactionLine			
						WHERE  Journal         = '#getGL.Journal#'
						AND    JournalSerialNo = '#getGL.JournalSerialNo#'			
					</cfquery>
					
					<cfloop query="getGLLines">
				
						<cfquery name="setGLTransaction"
						datasource="AppsMaterials" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						
						UPDATE Accounting.dbo.TransactionLine
						SET    TransactionAmount    = '#val#',
							   AmountDebit          = '#val#',
							   AmountBaseDebit      = '#val#'	
						WHERE  TransactionLineId    = '#TransactionLineId#'				
						AND    (AmountDebit > 0)
						
						UPDATE Accounting.dbo.TransactionLine
						SET    TransactionAmount    = '#val#',
							   AmountCredit         = '#val#',
							   AmountBaseCredit     = '#val#'	
						WHERE  TransactionLineId    = '#TransactionLineId#'				
						AND    (AmountCredit > 0)			
						
						</cfquery>		
					
					</cfloop>	
							
				</cfloop>	
				
			</cfloop>
		
		</cftransaction>   				
				
	</cffunction>		
	
	<!--- ------------------------------------ --->
	<!--- ----- 4. adjust stock pricing ------ --->
	<!--- ------------------------------------ --->
	
	<cffunction name="setStockPrice"
        access="public"
        returntype="any"
        displayname="adjust the price of stock for items that have a standard cost pricing set">
	
		<cfargument name="Mission"    type="string"  required="true"   default="">	
		<cfargument name="ItemNo"     type="string"  required="true"   default="">	
		<cfargument name="UoM"        type="string"  required="true"   default="">	
		<cfargument name="Price"      type="string"  required="true"   default="">	
		
		<cfquery name="Item"
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT *
			FROM   Item
			WHERE  ItemNo = '#itemNo#'
		</cfquery>
		
		<cf_verifyOperational 
		         datasource= "AppsMaterials"
		         module    = "Accounting" 
				 Warning   = "No">
		
		<cfquery name="Category"
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT * 
				FROM   Ref_CategoryGLedger 
			    WHERE  Category = '#item.Category#'
				AND    Area     = 'Stock'	
				<!--- Now we do the GL correction --->
				<cfif operational eq "1">
				AND    GLAccount IN (SELECT GLAccount 
				                     FROM   Accounting.dbo.Ref_Account)			
				</cfif>
		</cfquery>
		
		<cfif Category.recordcount eq "0">
					    
		  	 <cf_alert message = "Stock GL account for #Item.Category# does not exist">
			 <cfabort>
					
		</cfif>		

		<cfquery name="itemuom"
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT *
				FROM   ItemUoM
				WHERE  ItemNo = '#itemNo#'
				AND    UoM    = '#uom#'
		</cfquery>

		<cfif ItemUom.recordcount eq "0" 
				or Item.ValuationCode neq "Manual">

		    <!--- ----------------------- --->
		    <!--- no effect for LIFO/FIFO --->
			<!--- ----------------------- --->
 
		<cfelse>
					
			<!--- 1. Update all incoming transactions that have NOT been sourced AT ALL yet --->
				
			<cfquery name="update"
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				UPDATE  ItemTransaction
				SET     TransactionCostPrice = #price#,
				        TransactionValue     = #price# * S.transactionQuantity	
				FROM    ItemTransaction S		
				WHERE   TransactionQuantity > 0 
				AND     Mission              = '#mission#'
				AND     ItemNo               = '#itemNo#' 
				AND     TransactionUoM       = '#uom#'
				AND     TransactionId NOT IN (SELECT TransactionId
				                              FROM   Materials.dbo.ItemTransactionValuation 
											  WHERE  TransactionId = S.TransactionId)
			</cfquery>
		
			<!--- 2. Then we split transactions that have been partially sourced into old portion and new portion --->
			
			<cfquery name="selected"
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT     T.TransactionId AS TraId,
				           T.TransactionQuantity, 
				           SUM(V.TransactionQuantity) AS Processed
				FROM       ItemTransaction T INNER JOIN
			               Materials.dbo.ItemTransactionValuation V ON T.TransactionId = V.TransactionId
				WHERE      T.TransactionQuantity > 0 
				AND        Mission          = '#mission#'
				AND        T.ItemNo         = '#itemNo#' 
				AND        T.TransactionUoM = '#uom#'
				GROUP BY   T.TransactionId, T.TransactionQuantity
				HAVING     (SUM(V.TransactionQuantity) < T.TransactionQuantity)	
			</cfquery>
	
			<cfloop query="selected">	
				
				<!--- generate new line --->
				
				<cfquery name="update"
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					INSERT INTO ItemTransaction 
					
							( Mission,
							  Warehouse, 
							  TransactionType, 
							  TransactionDate, 
							  ItemNo, 
							  ItemDescription, 
							  ItemCategory, 
							  ItemPrecision, 
							  Location, 
							  TransactionQuantity, 
				              TransactionUoM, 
							  TransactionUoMMultiplier, 			 
							  TransactionCostPrice, 
							  TransactionValue, 
							  TransactionBatchNo, 
							  ReceiptId, 
				              ReceiptCostPrice, 
							  RequestId, 
							  WorkOrderId, 
							  ProgramCode, 
							  OrgUnit, 
							  OrgUnitCode, 
							  OrgUnitName, 
							  Remarks, 
							  ActionStatus, 
							  GLAccountDebit, 
				              GLAccountCredit, 
							  OfficerUserId, 
							  OfficerLastName, 
							  OfficerFirstName
							  )
					  
					SELECT Mission,
						   Warehouse, 
						   TransactionType, 
						   TransactionDate, 
						   ItemNo, 
						   ItemDescription, 
						   ItemCategory, 
						   ItemPrecision, 
						   Location, 
						   TransactionQuantity-#processed#, 
			               TransactionUoM, 
						   TransactionUoMMultiplier, 			 
						   '#price#', 
						   (TransactionQuantity-#processed#)*#price#, 
						   TransactionBatchNo, 
						   ReceiptId, 
			               ReceiptCostPrice, 
						   RequestId, 
						   WorkOrderId, 
						   ProgramCode, 
						   OrgUnit, 
						   OrgUnitCode, 
						   OrgUnitName, 
						   'Split line for value adjustment', 
						   ActionStatus, 
						   GLAccountDebit, 
			               GLAccountCredit, 
						   OfficerUserId, 
						   OfficerLastName, 
						   OfficerFirstName		
						  	  
					FROM   ItemTransaction
					
					WHERE  TransactionId = '#traId#'
					
				</cfquery>
				
				<!--- and adjust the processed value so it matches nicely --->
				
				<cfquery name="update"
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					UPDATE   ItemTransaction 
					SET      TransactionQuantity = #Processed#,
					         TransactionValue    = TransactionCostPrice*#Processed#
					WHERE    TransactionId = '#traId#' 
				</cfquery>
				
			</cfloop>	
			
			<!--- as we corrected the stock valuations we now get the value of the ledger for the GL stock account 
			to which this item belongs. Technically it corrects also the stock valuation --->
					
			<cfquery name="ValueGL"
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT  SUM(TransactionValue) as Value 				      
				FROM    ItemTransaction	V	
				WHERE   Mission        = '#mission#'				
				AND     ItemNo IN (
				                   SELECT ItemNo 
				                   FROM   Item 
								   WHERE  ItemNo = V.ItemNo 
								   AND    Category IN (
								                       SELECT Category 
								                       FROM   Ref_CategoryGLedger 
													   WHERE  Area      = 'Stock'
													   AND    GLAccount = '#Category.GLaccount#'
													  )
								 )					   
								
			</cfquery>
			
			<!--- Now we do the GL correction --->
						
			<cf_verifyOperational 
		         datasource= "AppsMaterials"
		         module    = "Accounting" 
				 Warning   = "No">
				
			<cfif operational eq "1">
			
				<cfloop query="ValueGL">
								 	
					<cfquery name="Journal" 
					    datasource="AppsMaterials" 
					    username="#SESSION.login#" 
					    password="#SESSION.dbpw#">
						SELECT    *
						FROM      Accounting.dbo.Journal
						WHERE     Mission       = '#Mission#' 
						AND       SystemJournal = 'Warehouse'
						AND       Currency      = '#application.baseCurrency#'
					</cfquery>
						
					<cfif Journal.recordcount eq "0">
																
							<cf_alert message = "A Warehouse Transaction Journal for #APPLICATION.BaseCurrency# has not been recorded for #Mission#. Operation not allowed."
							  return = "back">
							  <cfabort>
						  
					</cfif>  						
							
					<cfquery name="GLPrice" 
					   datasource="AppsMaterials" 
					   username="#SESSION.login#" 
					   password="#SESSION.dbpw#">
						   SELECT * 
						   FROM   Ref_CategoryGLedger 
						   WHERE  Area       = 'PriceChange'
						   AND    Category   = '#Item.Category#'
						   AND    GLAccount IN (SELECT GLAccount FROM Accounting.dbo.Ref_Account)
					</cfquery>	
							
					<cfif GLPrice.recordcount eq "0">
									    
						 <cf_alert message = "-Price change- GL account for #Item.Category# does not exist">
						 <cfabort>
									
					</cfif>
					
					<cfquery name="Current" 
					    datasource="AppsMaterials" 
					    username="#SESSION.login#" 
					    password="#SESSION.dbpw#">
							SELECT   SUM(L.AmountBaseDebit - L.AmountBaseCredit) AS GLValue
							FROM     Accounting.dbo.TransactionHeader H INNER JOIN
					                 Accounting.dbo.TransactionLine L ON H.Journal = L.Journal AND H.JournalSerialNo = L.JournalSerialNo
							WHERE    H.Mission           = '#Mission#' 
							AND      H.TransactionSource = 'WarehouseSeries'
							AND      L.GLAccount         = '#Category.GLaccount#'
					</cfquery>	
					
					<cfset diff = ValueGL.Value - Current.GLValue>
								
					<cfif abs(diff) gt "0.05">					
				
						<cf_GledgerEntryHeader
						    DataSource            = "AppsMaterials"
							Mission               = "#Mission#"			
							Journal               = "#Journal.Journal#" 
							Description           = "#ItemNo# #Item.Itemdescription#"
							TransactionSource     = "WarehouseSeries"					
							TransactionCategory   = "Inventory"					
							MatchingRequired      = "0"
							Reference             = "Cost Price change"       
							ReferenceName         = "#Item.Itemdescription#"					
							ReferenceNo           = "#itemNo#"
							DocumentCurrency      = "#APPLICATION.BaseCurrency#"					
							DocumentAmount        = "#diff#"
							AmountOutstanding     = "0">							
																		 
						<cf_GledgerEntryLine
						    DataSource            = "AppsMaterials"
							Lines                 = "2"
							Journal               = "#Journal.Journal#"
							JournalNo             = "#JournalTransactionNo#"					
							Currency              = "#APPLICATION.BaseCurrency#"												
							
							TransactionSerialNo1  = "1"
							Class1                = "debit"
							Reference1            = "Price change"       
							ReferenceName1        = "#left(Item.Itemdescription,100)#"
							Description1          = "Price change"
							GLAccount1            = "#Category.GLaccount#"				
							ReferenceNo1          = "#ItemNo#"
							TransactionType1      = "Standard"
							Amount1               = "#diff#"								
							
							TransactionSerialNo2  = "2"
							Class2                = "credit"
							Reference2            = "Price change"       
							ReferenceName2        = "#left(Item.Itemdescription,100)#"
							Description2          = "Price change"
							GLAccount2            = "#GLPrice.GLAccount#"				
							ReferenceNo2          = "#ItemNo#"
							TransactionType2      = "Standard"
							Amount2               = "#diff#">
							
						</cfif>	
						
				</cfloop>			
			
			</cfif>		
				
		</cfif>
		
		</cffunction>		
		
		<!--- --------------------------------- --->
		<!--- ----- 5. set stock ledger-------- --->
		<!--- --------------------------------- --->
		
		<cffunction name="setStockLedger"
        access="public"
        returntype="any"
        displayname="adjust the price of stock through standard cost variable">
	
			<cfargument name="Datasource"   type="string"  required="true"   default="appsMaterials">	
			<cfargument name="ItemNo"       type="string"  required="true"   default="">	
			<cfargument name="CategoryNew"  type="string"  required="true"   default="">	
			<cfargument name="CategoryOld"  type="string"  required="true"   default="">	
			
			<!--- thsi component is deprecated, and no longer used as its transactions are to tricky, my idea
			is to change through creating a new item or manual fix --->
			
						
			<!--- To improve performance Armin changed IN statement to NOT EXIST --->
						
			<!---
			
			The custom method handles the following scenarios for General Ledger sync 
			
			Warehouse Financials
			
			1. Edit of the glaccount code for [stock] in the category ledger maintenance
			
				Need to change the old GL code into the new stock account in financials
				(universal fix as below)
			
			2. Change of category for an item when the category has a different stock account
			
				Need to change the old GL code into the new stock account in financials
				(universal fix as below)
			
			3. Change standard cost price 100-110 and mode is manual
			
				Define any sourcing transactions that have have stock (loop)
			
				- Create a negative transaction so we source it all
				- Create a positive transaction so we have stock again but against a new value
			
				Define value in Warehouse transactionsLedger for that whole category of the item 
				(GL code)
			
				Make a price diffence correction
			
			4. Move from method FIFO/LIFO to manual
			
				Same procedure as point 3
			
			5. Move from Manual to FIFO/LIFO
			
				No action, it does not have to work retroactively
			
			--->
			
			<!--- reminder !!!!! also exclude depreciation --->
							
			
			<cfquery name="AccountNew" 
					datasource="#Datasource#" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT   *
					FROM     Ref_Category R INNER JOIN
					         Ref_CategoryGledger L ON R.Category = L.Category
					WHERE    L.Area = 'Stock' 
					AND      R.Category = '#categorynew#'
			</cfquery>	
								
			<cfquery name="AccountOld" 
					datasource="#Datasource#" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT   *
					FROM     Ref_Category R INNER JOIN
					         Ref_CategoryGledger L ON R.Category = L.Category
					WHERE    L.Area = 'Stock' 
					AND      R.Category = '#categoryold#'
			</cfquery>	
			
			<cfset newaccount = AccountNew.GLAccount>
			<cfset oldaccount = AccountOld.GLAccount>

			<cfif AccountNew.GLAccount eq AccountOld.GLAccount>
			
				<!--- no action needed here as effectively no changes were made --->
			
			<cfelse>
			
				<cf_verifyOperational 
			         datasource= "#Datasource#"
			         module    = "Accounting" 
					 Warning   = "No">
					 
				<cfif Operational eq "1"> 
					
					<!--- ----------------------------------------------- --->
					<!--- define the correct GL values of stock and asset --->
					<!--- ----------------------------------------------- --->
					
					<cfloop index="itemclass" list="Asset,Supply">
					
						<cfif itemclass eq "Supply">
						
						    <!--- -------- --->
						    <!--- supplies --->
							<!--- -------- --->
						
							<cfquery name="ItemTransaction" 
								datasource="#Datasource#" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
								
								<!--- retrieve all transactions involved for this category and prior category and define the
								determined new value for the associated GL account of the involved categories --->
								
								SELECT     IT.Mission,	
										   R.GLAccount, 						       
								           SUM(IT.TransactionValue) AS Amount <!--- calculated value --->
										
								FROM       Materials.dbo.ItemTransaction IT INNER JOIN
							               Materials.dbo.Item I ON IT.ItemNo = I.ItemNo INNER JOIN
							               Materials.dbo.Ref_CategoryGledger R ON I.Category = R.Category and R.Area = 'Stock'	
								
								<!--- take all items that belong to either of the two categories at stake --->
										   
								WHERE      I.Category IN ('#categorynew#','#categoryold#') 
								
								AND        NOT EXISTS 
																(
																 SELECT TransactionId 
								                                 FROM   Materials.dbo.AssetItem 
																 WHERE  TransactionId = IT.TransactionId
																 )		
																	
								AND        I.ItemClass = 'Supply'									
													
								GROUP BY   IT.Mission,
								           R.GLAccount			
								
								ORDER BY   IT.Mission 
										
							</cfquery>		
							
							<!--- ------------------------------------------------------------------------------------- --->
							<!--- complement the query objecy with 0 value if the old GL would not longer have presence --->
							
							<cfloop query="ItemTransaction">
							
								<cfquery name="Check" dbtype="query">
									SELECT * 
									FROM   ItemTransaction
									WHERE  Mission = '#mission#'
									AND    GLAccount = '#AccountOld.GLAccount#'								
								</cfquery>
											
								<cfif check.recordcount eq "0">
																		
								    <cfset queryaddrow(ItemTransaction, 1)>
														
									<!--- set values in cells --->
									<cfset querysetcell(ItemTransaction, "Mission", "#Mission#")>
									<cfset querysetcell(ItemTransaction, "GLAccount", "#AccountOld.GLAccount#")>
									<cfset querysetcell(ItemTransaction, "Amount", "0")>																				
							
								</cfif>
							
							</cfloop>
							
							<cfquery name="LedgerBase" dbtype="query">
									SELECT * 
									FROM   ItemTransaction										
							</cfquery>
											
						<cfelse>
						
							<!--- select all asset items under this master item for the value as per asset show, each asset item
							has one GLAccount so the query is different  --->
							
							<!--- ------------------- --->
						    <!--- Assets source value --->
							<!--- ------------------- --->
										
							<cfquery name="LedgerBase" 
								datasource="#Datasource#" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
															
								SELECT     A.AssetId,
								           A.Mission,
								           '#newaccount#' as GLAccount, 	
									       I.Category,	
										   I.ItemNo,     					   			   
								           SUM(A.DepreciationBase-A.DepreciationCumulative) AS Amount <!--- calculated value --->
										   <!--- actual --->
								FROM       Materials.dbo.ItemTransaction IT INNER JOIN
										   Materials.dbo.Item I ON IT.ItemNo = I.ItemNo INNER JOIN
								           Materials.dbo.Ref_CategoryGledger R ON I.Category = R.Category AND R.Area = 'Stock' INNER JOIN
								           Materials.dbo.AssetItem A ON A.TransactionId = IT.TransactionId		
								
								<!--- now all asset items that belong to the same category so we correct them all if needed --->
										   
								WHERE      I.Category = '#categorynew#'
													
								AND        IT.TransactionType = '1'
								
								GROUP BY   A.Mission,
								           A.AssetId,			          							  
										   I.Category,	
										   I.ItemNo   
										   				
								ORDER BY   A.Mission, 
								           A.AssetId 
										
							</cfquery>		
						
						</cfif>						
								
					    <!--- process the defined CORRECT stock values for each glaccount into the ledger --->
							  
						<cfoutput query="LedgerBase" group="mission">	
						
						    <cfset row = 0>	
							<cfset sel = "">
							<cfset header = "0">
											
							<!--- retrieve journal --->
										
							<cfquery name="Journal" 
							   datasource="#Datasource#" 
							   username="#SESSION.login#" 
							   password="#SESSION.dbpw#">
									SELECT    *
									FROM      Accounting.dbo.Journal
									WHERE     Mission       = '#Mission#' 
									AND       SystemJournal = 'Warehouse'
									AND       Currency      = '#APPLICATION.BaseCurrency#'
							 </cfquery>
							 	 
							<cfquery name="GLCorrection" 
							   datasource="#Datasource#" 
							   username="#SESSION.login#" 
							   password="#SESSION.dbpw#">
								   SELECT * 
								   FROM   Accounting.dbo.Ref_AccountMission 
								   WHERE  Mission       = '#Mission#'
								   AND    SystemAccount = 'Correction'		   
							</cfquery>
						
							<cfif GLCorrection.recordcount eq "0">
								   
								 <cf_waitend>   
						  		 <cf_message message = "GL ACCOUNT MAINTENANCE: A System GL Account for type: Correction has not been declared for #Mission#.">
								 <cfabort>
								
							</cfif>								
						
						    <!--- actual loop within the mission starts here --->
							
							<cfoutput>
																	
								<!--- define value in the general ledger for each determined account to be review OR 
								   for each individual asset, by EXCLUDING the opening balance transaction I can check the full database --->	
								   
								<cfif ItemClass eq "Supply">   		
											
									<cfquery name="Ledger" 
										datasource="#Datasource#" 
										username="#SESSION.login#" 
										password="#SESSION.dbpw#">
														
										SELECT    L.GLAccount, 
												  SUM(L.AmountBaseDebit) - SUM(L.AmountBaseCredit) AS LedgerValue
										FROM      Accounting.dbo.TransactionHeader H 
												  INNER JOIN Accounting.dbo.TransactionLine L ON H.Journal = L.Journal AND H.JournalSerialNo = L.JournalSerialNo
												  INNER JOIN Accounting.dbo.Ref_Account R ON L.GLAccount = R.GLAccount 
												  INNER JOIN Accounting.dbo.Journal J ON L.Journal = J.Journal
										WHERE     H.Mission      = '#Mission#'
										AND       R.AccountClass = 'Balance' 
										AND       R.AccountType  = 'Debit'     
										
										AND       J.SystemJournal IN ('Warehouse','Asset') 									
										
										<!--- determined account --->
										AND       L.GLAccount  = '#GLAccount#' 
										
										AND       NOT EXISTS (SELECT AssetId 
										                      FROM   Materials.dbo.AssetItem
															  WHERE  AssetId = L.ReferenceId
															)
										GROUP BY  L.GLAccount 	
																		
									</cfquery>	
									
								<cfelse>
								
									    <!--- we only take the transactions that belong to this asset item and as balance bookings to ensure we deal with stock value --->
								
									   <cfquery name="Ledger" 
										datasource="#Datasource#" 
										username="#SESSION.login#" 
										password="#SESSION.dbpw#">
														
										SELECT    SUM(L.AmountBaseDebit) - SUM(L.AmountBaseCredit) AS LedgerValue
										FROM      Accounting.dbo.TransactionHeader H 
												  INNER JOIN Accounting.dbo.TransactionLine L ON H.Journal = L.Journal AND H.JournalSerialNo = L.JournalSerialNo
												  INNER JOIN Accounting.dbo.Ref_Account R ON L.GLAccount = R.GLAccount 
												  INNER JOIN Accounting.dbo.Journal J ON L.Journal = J.Journal
										WHERE     H.Mission      = '#Mission#'
										AND       R.AccountClass = 'Balance' 
										AND       R.AccountType  = 'Debit'     							
										AND       J.SystemJournal IN ('Warehouse','Asset') 																													
										AND       L.ReferenceId  = '#assetid#'							
								        </cfquery>
								
								</cfif>												
									
								<!--- ---------------------------------------- --->	
								<!--- tracking of accounts to be cleared below --->
								<!--- ---------------------------------------- --->
											
								<cfif sel eq "">
								    <cfset sel = "'#GLAccount#'">		
								<cfelse>
								    <cfset sel = "#sel#,'#GLAccount#'">		
								</cfif> 
								
								<!--- ---------------------------------------- --->
												
								<cfif amount eq "">
								   <cfset amount = "0">
								</cfif>
																
								<cfset whsval = amount>
												
								<cfif Ledger.LedgerValue eq "">								
									 <cfset glval = 0>
								<cfelse>								
									 <cfset glval = Ledger.LedgerValue> 
								</cfif>
														
								<!--- supplies --->
								
							<cfif ItemClass eq "Supply">
																							
								<cfif abs(whsval-glval) gte "0.5">
											
										<cfset diff = round((whsval-glval)*100)/100>
											
										<!--- transaction for difference --->
										
										<cfset row = row+1>
										
										<cfif header eq "0">
									
											<cf_GledgerEntryHeader
											    DataSource            = "#Datasource#"
												Mission               = "#Mission#"			
												Journal               = "#Journal.Journal#" 
												Description           = "Stock Correction"
												TransactionSource     = "WarehouseSeries"
												TransactionCategory   = "Inventory"			
												MatchingRequired      = "0"
												Reference             = "Warehouse"       
												ReferenceName         = "Change of Stock GL Account"
												ReferenceId           = ""
												ReferenceNo           = ""
												DocumentCurrency      = "#APPLICATION.BaseCurrency#"			
												DocumentAmount        = "0"
												AmountOutstanding     = "0">
												
												<cfif diff lt 0>
													<cfset cl = "Credit">
													<cfset ct = "Debit">
													<cfset diff = -diff>
												<cfelse>
												    <cfset cl = "Debit">
													<cfset ct = "Credit">
												</cfif>	
																																																				
												<cf_GledgerEntryLine
												    DataSource            = "#Datasource#"
													Lines                 = "2"
													Journal               = "#Journal.Journal#"
													JournalNo             = "#JournalTransactionNo#"					
													Currency              = "#APPLICATION.BaseCurrency#"
																		
													TransactionSerialNo1  = "#row#"
													Class1                = "#cl#"									
													Reference1            = "Account Correction"       
													ReferenceName1        = "Account Correction from Source"					
													GLAccount1            = "#glaccount#"										
													TransactionType1      = "Standard"
													Amount1               = "#diff#"
																																		
													TransactionSerialNo2  = "0"
													Class2                = "#ct#"									
													Reference2            = "ContraAccount"       
													ReferenceName2        = "Account Correction from Source"					
													GLAccount2            = "#GLCorrection.GLAccount#"					
													TransactionType2      = "Contra-Account"
													Amount2               = "#diff#">
													
													<cfset header = "1">		
																																												
										<cfelse>		
										
												<cfif diff lt 0>
													<cfset cl = "Credit">
													<cfset ct = "Debit">
													<cfset diff = -diff>
												<cfelse>
												    <cfset cl = "Debit">
													<cfset ct = "Credit">
												</cfif>	
										
												<cf_GledgerEntryLine
												    DataSource            = "#Datasource#"
													Lines                 = "2"
													Journal               = "#Journal.Journal#"
													JournalNo             = "#JournalTransactionNo#"					
													Currency              = "#APPLICATION.BaseCurrency#"
																		
													TransactionSerialNo1  = "#row#"
													Class1                = "#cl#"									
													Reference1            = "Account Correction"       
													ReferenceName1        = "Account Correction from Source"					
													GLAccount1            = "#glaccount#"										
													TransactionType1      = "Standard"
													Amount1               = "#diff#"
													
													TransactionSerialNo2  = "0"
													Class2                = "#ct#"									
													Reference2            = "ContraAccount"       
													ReferenceName2        = "Account Correction from Source"					
													GLAccount2            = "#GLCorrection.GLAccount#"					
													TransactionType2      = "Contra-Account"
													Amount2               = "#diff#">																
											
										</cfif>	
										
										
														
								</cfif>	
							
							<cfelse>
							
								<!--- check if each asset is booked on the same account and value --->
								
								<cfset row = "0">
																								
								<cfif whsval eq "">
									<cfset whsval = 0>
								</cfif>
												
								<cfset diff = whsval - glval>															
								
																			
						 		<!--- we only rebook if we find any existing transaction for this asset item --->
								
								<cfquery name="Exist" 
								datasource="#Datasource#" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">												
									SELECT    *
									FROM      Accounting.dbo.TransactionLine
									WHERE     ReferenceId  = '#assetid#'											
							   </cfquery>									
									   
							   <cfif Exist.recordcount eq "0">
							   
							   		<!--- create an initial value for this asset --->
								
									<cf_GledgerEntryHeader
										    DataSource            = "#Datasource#"
											Mission               = "#LedgerBase.Mission#"			
											Journal               = "#Journal.Journal#" 
											Description           = "Stock Correction"
											TransactionSource     = "AssetSeries"
											TransactionCategory   = "Inventory"			
											MatchingRequired      = "0"
											Reference             = "Warehouse"       
											ReferenceName         = "Correction of Stock GL Account"
											ReferenceId           = "#LedgerBase.AssetId#"
											ReferenceNo           = ""
											DocumentCurrency      = "#APPLICATION.BaseCurrency#"			
											DocumentAmount        = "#whsval#"
											AmountOutstanding     = "0">
									
										<!--- Lines --->
																				 
										<cf_GledgerEntryLine
										    DataSource            = "#Datasource#"
											Lines                 = "2"
											Journal               = "#Journal.Journal#"
											JournalNo             = "#JournalTransactionNo#"					
											Currency              = "#APPLICATION.BaseCurrency#"
																
											TransactionSerialNo1  = "1"
											Class1                = "Debit"
											ReferenceId1          = "#LedgerBase.AssetId#"
											Description1          = "Asset correction booking"		
											Reference1            = "Overbooking"       
											ReferenceName1        = "Overbooking"					
											GLAccount1            = "#newaccount#"										
											TransactionType1      = "Standard"
											Amount1               = "#whsval#"
												
											TransactionSerialNo2  = "2"
											Class2                = "Credit"
											ReferenceId2          = "#LedgerBase.AssetId#"
											Description2          = "Asset overbooking for master item"											
											Reference2            = "ContraAccount"       
											ReferenceName2        = "Account Correction from Source"					
											GLAccount2            = "#GLCorrection.GLAccount#"					
											TransactionType2      = "Contra-Account"
											Amount2               = "#whsval#">	
											
									<cfelse>	
									
										<!--- get stocklines for this which stock bookings are on a different stock Account --->
									
										<cfquery name="Lines" 
										datasource="#Datasource#" 
										username="#SESSION.login#" 
										password="#SESSION.dbpw#">												
											SELECT    L.GLAccount, 
													  SUM(L.AmountBaseDebit) - SUM(L.AmountBaseCredit) AS LedgerValue
											FROM      Accounting.dbo.TransactionHeader H 
													  INNER JOIN
									                  Accounting.dbo.TransactionLine L ON H.Journal = L.Journal AND H.JournalSerialNo = L.JournalSerialNo
													  INNER JOIN
											          Accounting.dbo.Ref_Account R ON L.GLAccount = R.GLAccount 
													  INNER JOIN
											          Accounting.dbo.Journal J ON L.Journal = J.Journal
											WHERE     R.AccountClass = 'Balance' 
											AND       J.SystemJournal IN ('Warehouse','Asset') 
											AND       R.AccountType = 'Debit'				
											AND       H.Mission      = '#Mission#'
											AND       L.GLAccount    != '#GLAccount#'
											AND       L.ReferenceId  = '#assetid#'
											GROUP BY  L.GLAccount 			
									   </cfquery>		
									   									 						   					   
									   <cfloop query="Lines">
									   
									       <!---
									         #LedgerValue# - from:#GLAccount# to:#newaccount#<br>
											 --->
									  																	   					   
									   	   <!--- step 1 rebook any balance transactions for this asset first --->
									
										   <cf_GledgerEntryHeader
											    DataSource            = "#Datasource#"
												Mission               = "#LedgerBase.Mission#"			
												Journal               = "#Journal.Journal#" 
												Description           = "Stock Correction"
												TransactionSource     = "AssetSeries"
												TransactionCategory   = "Inventory"			
												MatchingRequired      = "0"
												Reference             = "Warehouse"       
												ReferenceName         = "Overbooking GL Account"
												ReferenceId           = "#LedgerBase.AssetId#"
												ReferenceNo           = ""
												DocumentCurrency      = "#APPLICATION.BaseCurrency#"			
												DocumentAmount        = "#LedgerValue#"
												AmountOutstanding     = "0">
										
											<!--- Lines --->
																					 
											<cf_GledgerEntryLine
											    DataSource            = "#Datasource#"
												Lines                 = "2"
												Journal               = "#Journal.Journal#"
												JournalNo             = "#JournalTransactionNo#"					
												Currency              = "#APPLICATION.BaseCurrency#"
																	
												TransactionSerialNo1  = "1"
												Class1                = "Debit"
												ReferenceId1          = "#LedgerBase.AssetId#"
												Description1          = "Asset overbooking for master item change"		
												Reference1            = "Overbooking"       
												ReferenceName1        = "Overbooking"					
												GLAccount1            = "#newaccount#"										
												TransactionType1      = "Standard"
												Amount1               = "#LedgerValue#"
													
												TransactionSerialNo2  = "2"
												Class2                = "Credit"
												ReferenceId2          = "#LedgerBase.AssetId#"
												Description2          = "Asset overbooking for master item change"											
												Reference2            = "ContraAccount"       
												ReferenceName2        = "Account Correction"					
												GLAccount2            = "#GLAccount#"					
												TransactionType2      = "Contra-Account"
												Amount2               = "#LedgerValue#">	
												
									  </cfloop>	
									 
									 										
									  <!--- 2. Then correct for a potential difference --->
									  
									  <cfif abs(diff) gte "1">
									  
									      <!---
									  
										  	#LedgerBase.AssetId#: #diff# <br>
										
											--->
																												
										  <cf_GledgerEntryHeader
												    DataSource            = "#Datasource#"
													Mission               = "#LedgerBase.Mission#"			
													Journal               = "#Journal.Journal#" 
													Description           = "Stock Correction"
													TransactionSource     = "AssetSeries"
													TransactionCategory   = "Inventory"			
													MatchingRequired      = "0"
													Reference             = "Warehouse"       
													ReferenceName         = "Correction of Stock GL Account"
													ReferenceId           = "#LedgerBase.AssetId#"
													ReferenceNo           = ""
													DocumentCurrency      = "#APPLICATION.BaseCurrency#"			
													DocumentAmount        = "#diff#"
													AmountOutstanding     = "0">
											
													<!--- Lines --->
																								 
													<cf_GledgerEntryLine
														    DataSource            = "#Datasource#"
															Lines                 = "2"
															Journal               = "#Journal.Journal#"
															JournalNo             = "#JournalTransactionNo#"					
															Currency              = "#APPLICATION.BaseCurrency#"
																				
															TransactionSerialNo1  = "1"
															Class1                = "Debit"
															ReferenceId1          = "#LedgerBase.AssetId#"
															Description1          = "Asset Value Correction"		
															Reference1            = "Overbooking"       
															ReferenceName1        = "Overbooking"					
															GLAccount1            = "#newaccount#"										
															TransactionType1      = "Standard"
															Amount1               = "#diff#"
																
															TransactionSerialNo2  = "2"
															Class2                = "Credit"
															ReferenceId2          = "#LedgerBase.AssetId#"
															Description2          = "Asset Value correction"											
															Reference2            = "ContraAccount"       
															ReferenceName2        = "Account Correction from Source"					
															GLAccount2            = "#GLCorrection.GLAccount#"					
															TransactionType2      = "Contra-Account"
															Amount2               = "#diff#">	
												
										</cfif>		
											
									</cfif>	
										   															
								</cfif>								
														
							</cfoutput>		
																					
							<!--- -------------------- This applies to a general cleanup----- ---------------------------------- --->
							<!--- Any ledger bookings for supplies that do not have a tracable value in ItemTransaction anymore  --->
							<!--- ---------------------------------------------------------------------------------------------- --->	
							<!--- -------define any value of the GL account for the balance account in journal : Warehouse------ --->
																
								<cfquery name="Missing" 
									datasource="#Datasource#" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
										SELECT    L.GLAccount, 
										          SUM(L.AmountBaseDebit) - SUM(L.AmountBaseCredit) AS Value
										FROM      Accounting.dbo.TransactionHeader H 
												  INNER JOIN
								                  Accounting.dbo.TransactionLine L ON H.Journal = L.Journal AND H.JournalSerialNo = L.JournalSerialNo
												  INNER JOIN
										          Accounting.dbo.Ref_Account R ON L.GLAccount = R.GLAccount 
												  INNER JOIN
										          Accounting.dbo.Journal J ON L.Journal = J.Journal
										WHERE     R.StockAccount = '1' 
										AND       J.SystemJournal IN ('Warehouse','Asset')					
										AND       H.Mission = '#mission#'
															
										AND       NOT EXISTS (
																			<!--- account no longer has a value exists in the materials reality but does have a value in GL --->
																			SELECT    R.GLAccount
																			FROM      ItemTransaction IT INNER JOIN
																			          Item I ON IT.ItemNo = I.ItemNo INNER JOIN
																			          Ref_CategoryGledger R ON I.Category = R.Category AND R.Area = 'Stock'
																			WHERE 
																					R.GlAccount = L.GLAccount 
																			GROUP BY R.GLAccount
																			HAVING      (SUM(IT.TransactionValue) > 0)
																	)
															
										AND   NOT EXISTS (SELECT AssetId FROM Materials.dbo.AssetItem WHERE AssetId = L.ReferenceId)				
										<!--- important, do not change source !!!! --->
										AND       L.TransactionType <> 'Contra-Account'				
										GROUP BY  L.GLAccount  
										HAVING abs(SUM(L.AmountBaseDebit) - SUM(L.AmountBaseCredit)) > 0 
								</cfquery>
											
								<cfset mis = mission>
								
								<cfloop query="Missing">
								
									<!--- transaction for difference --->
									
									<cfif abs(Value) gte 1>
									
									<cf_GledgerEntryHeader
									    DataSource            = "#Datasource#"
										Mission               = "#Mis#"			
										Journal               = "#Journal.Journal#" 
										Description           = "Stock Correction"
										TransactionSource     = "WarehouseSeries"
										TransactionCategory   = "Inventory"			
										MatchingRequired      = "0"
										Reference             = "Warehouse"       
										ReferenceName         = "Account not in source"
										ReferenceId           = ""
										ReferenceNo           = ""
										DocumentCurrency      = "#APPLICATION.BaseCurrency#"			
										DocumentAmount        = "#value#"
										AmountOutstanding     = "0">
									
										<!--- Lines --->
																				 
										<cf_GledgerEntryLine
										    DataSource            = "appsMaterials"
											Lines                 = "2"
											Journal               = "#Journal.Journal#"
											JournalNo             = "#JournalTransactionNo#"					
											Currency              = "#APPLICATION.BaseCurrency#"
																
											TransactionSerialNo1  = "1"
											Class1                = "Credit"
											Reference1            = "Stock Correction"       
											ReferenceName1        = "Empty account"	
											Description1          = "Account no longer used"				
											GLAccount1            = "#GLAccount#"										
											TransactionType1      = "Standard"
											Amount1               = "#value#"
												
											TransactionSerialNo2  = "2"
											Class2                = "Debit"
											Reference2            = "ContraAccount"       
											ReferenceName2        = "Account Correction from Source"					
											GLAccount2            = "#GLCorrection.GLAccount#"					
											TransactionType2      = "Contra-Account"
											Amount2               = "#value#">
											
									</cfif>			
									
								</cfloop>												
										
						</cfoutput>	
						
					</cfloop>	
						
				</cfif>
			
			</cfif>				
				
		</cffunction>				
	
</cfcomponent>		
	