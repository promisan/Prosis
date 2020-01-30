<!--- Generate COGS sold transactions --->
	
	<cfset thisActionStatus = "1">

	<cfquery name="ListIssuances" 
		datasource="AppsLedger" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
		SELECT   
		/*C.*,I.Category*/  
				C.WorkOrderChargeId,C.WorkOrderID,C.WorkOrderLine,
	   			--special for Surgeries, must count if 1 planned action, must decrease stock on this date, if not then take the TransactionDate for the billing
		 	CASE WHEN (SELECT COUNT(wla1.DateTimeplanning) 
				    FROM WorkORder.dbo.WorkOrderLineAction as wla1
					   INNER JOIN WorkOrder.dbo.WorkPlanDetail  as wpd1
					   ON wla1.WorkActionId = wpd1.WorkActionId
					   AND wla1.ActionClass = 'Contact'
					   WHERE wla1.WorkORderId = C.WorkORderID
					   AND wla1.WorkOrderLine = C.WorkOrderLine) = 1 THEN 
				(SELECT ISNULL(wpd1.DateTimePlanning,wla1.DateTimePlanning)
				 	FROM WorkORder.dbo.WorkOrderLineAction as wla1
				 	INNER JOIN WorkOrder.dbo.WorkPlanDetail  as wpd1
					ON wla1.WorkActionId = wpd1.WorkActionId
					AND wla1.ActionClass = 'Contact'
    				WHERE wla1.WorkORderId =C.WorkORderID
					AND wla1.WorkOrderLine = C.WorkOrderLine)
			 ELSE 
		  		C.TransactionDate 
		  	END AS TransactionDate
	   				,C.OrgUnit, C.OrgUnitOwner, C.OrgUnitCustomer,C.BillingReference,
	   				C.BillingName, C.InvoiceSeries, C.InvoiceNo, C.Unit, C.UnitDescription, C.UnitClass, C.Warehouse, C.ItemNo, C.ItemUoM, C.QuantityCost, C.Quantity,
	   				C.CostPrice, C.CostAmount, C.Currency, C.SalePrice, C.SaleTax, C.TaxCode, C.TaxIncluded, C.TaxExemption, C.SaleAmountDiscount, C.SaleAmountIncome,
	   				C.SaleAmountTax,C.SalePayable, C.GLAccountCredit, C.Journal, C.JournalSerialNo, C.OfficerUserId, C.OfficerLastName, C.OfficerFirstName
					, I.Category
		FROM      WorkOrder.dbo.WorkOrderLineCharge C, 
		          Materials.dbo.Item I, 
				  Materials.dbo.ItemUoM U
		WHERE     C.WorkOrderid   = '#get.WorkOrderid#' 
		AND       C.WorkOrderLine = '#get.WorkOrderLine#' 
		AND       C.ItemNo      = I.ItemNo
		AND       C.ItemNo      = U.ItemNo
		AND       C.ItemUoM     = U.UoM
		AND       C.QuantityCost > 0
		AND       C.Warehouse is not NULL
		--AND       C.Journal   is NULL
		ORDER BY  Warehouse
		
	</cfquery>	
	
	 <!--- remove the transaction and the financials if it exists already but leave the batch
	 so it can be reinstated --->
			
	<cfquery name="clear" 
		datasource="AppsLedger" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		DELETE FROM Materials.dbo.ItemTransaction
		WHERE  WorkOrderId   = '#get.workorderid#'	
		AND    WorkOrderLine = '#get.workorderline#'
		AND    TransactionType = '2'		
	</cfquery>	

	<cfoutput query="ListIssuances" group="warehouse">
					
			<!--- record the batch --->			
			
			<!--- check if batch exists --->
			
			<cfquery name="getBatch" 
			   datasource="AppsLedger" 
			   username="#SESSION.login#" 
			   password="#SESSION.dbpw#">
				   SELECT   TOP 1 *
				   FROM     Materials.dbo.WarehouseBatch
				   WHERE    Warehouse = '#warehouse#'
				   AND      BatchClass = 'WOMedical'
				   AND      BatchId    = '#get.WorkOrderLineId#'
				   ORDER BY BatchNo DESC
			</cfquery>
			
			<cfif getBatch.recordcount eq "1">
			
				<cfset batchNo = getBatch.BatchNo>
				<!---- must activate this batch that already exists------>
				<cfquery name="activateBatch" 
			   		datasource="AppsLedger" 
			   		username="#SESSION.login#" 
			   		password="#SESSION.dbpw#">
				   		UPDATE 	Materials.dbo.WarehouseBatch
				   		SET    	ActionStatus 	= '1'
				   		WHERE    BatchId  		= '#getBatch.BatchId#'
				   		AND    	BatchNo  		= '#getBatch.BatchNo#'
				</cfquery>
				
			<cfelse>			
									
				<cfquery name="Parameter" 
				   datasource="AppsLedger" 
				   username="#SESSION.login#" 
				   password="#SESSION.dbpw#">
					   SELECT   TOP 1 *
					   FROM     Materials.dbo.WarehouseBatch
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
				
				<cf_assignid>

								
				<cfquery name="Insert" 
				datasource="AppsLedger" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					INSERT INTO Materials.dbo.WarehouseBatch
						    (Mission,
							 Warehouse, 
							 BatchWarehouse,					
							 BatchReference,	
							 BatchDescription,	
						 	 BatchNo,
							 BatchClass, 	
							 BatchId,					 					
							 TransactionDate,
							 TransactionType, 					
							 ActionStatus,						
							 OfficerUserId, 
							 OfficerLastName, 
							 OfficerFirstName)
					VALUES 	('#get.mission#',
						     '#warehouse#',
							 '#warehouse#',					
							 'Medical Billing',
							 'Consumption of medical supplies',
							 '#batchNo#',	
							 'WOMedical',	
							 '#get.WorkOrderLineId#',					 														 
							 '#dateformat(transactionDate,CLIENT.DateSQL)#',
							 '2',					
							 '#thisActionStatus#',					 
							 '#SESSION.acc#',
							 '#SESSION.last#',
							 '#SESSION.first#')
				</cfquery>
				
			</cfif>	
			
		   <cfoutput>
			
			   		
			    <!--- create issuance transaction --->
				
				<cfquery name="AccountStock"
					datasource="AppsLedger" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    SELECT  GLAccount
						FROM    Materials.dbo.Ref_CategoryGLedger
						WHERE   Category  = '#Category#' 
						AND     Area      = 'Stock'
						AND     GLAccount IN (SELECT GLAccount FROM Accounting.dbo.Ref_Account)
				</cfquery>		
				
				<!--- first step we can look at the workorder account --->
																				
				<cfquery name="AccountCOGS"
					datasource="AppsLedger" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    SELECT  GLAccount
						FROM    Materials.dbo.Ref_CategoryGLedger
						WHERE   Category = '#Category#' 
						AND     Area     = 'COGS'
						AND     GLAccount IN (SELECT GLAccount 
						                      FROM   Accounting.dbo.Ref_Account)
				</cfquery>	
			
				<cf_StockTransact 
				    DataSource            = "AppsLedger" 
					TransactionId         = "#workorderchargeid#"	
				    TransactionType       = "2"  <!--- COGS --->
				    ActionStatus		  = "#thisActionStatus#"
					TransactionSource     = "WorkorderSeries"
					ItemNo                = "#ItemNo#" 
					Mission               = "#get.Mission#" 
					Warehouse             = "#Warehouse#" 					
					TransactionReference  = "#batchno#"
					TransactionCurrency   = "#APPLICATION.BaseCurrency#"
					TransactionQuantity   = "#QuantityCost*-1#"
					TransactionUoM        = "#ItemUoM#"						
					TransactionLocalTime  = "Yes"
					TransactionDate       = "#dateformat(transactionDate,CLIENT.DateFormatShow)#"
					TransactionTime       = "#timeformat(transactionDate,'HH:MM')#"
					TransactionBatchNo    = "#batchno#"															
					WorkOrderId           = "#workorderid#"
					WorkOrderLine         = "#workorderline#"	
					RequirementId         = "#workorderchargeid#"   <!--- important to keep the same --->
					OrgUnit               = "#orgunit#"
					GLAccountDebit        = "#AccountCOGS.GLAccount#"
					GLAccountCredit       = "#AccountStock.GLAccount#">	
				
			</cfoutput>		
	
	</cfoutput>