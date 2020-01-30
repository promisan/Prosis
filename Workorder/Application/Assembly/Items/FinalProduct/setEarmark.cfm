
<!--- set earmark --->

<cfquery name="get" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  	SELECT * 
		FROM   ItemTransaction
		WHERE  TransactionId = '#url.transactionid#'		
</cfquery>  

<cfset date = dateformat(now(),CLIENT.DateFormatShow)>
<CF_DateConvert>
<cfset dte = dateValue>		

<cfquery name="Category" 
   datasource="AppsMaterials" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   	 SELECT   *
	 FROM     Ref_Category
	 WHERE    Category = '#get.ItemCategory#' 
</cfquery>

<cfquery name="param" 
   datasource="AppsMaterials" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   	 SELECT   *
	 FROM     Ref_ParameterMission
	 WHERE    Mission = '#get.mission#' 
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

<cftransaction>
	
	<!--- record the batch --->
					
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
				 BatchClass,
				 BatchDescription,						
				 TransactionDate,
				 TransactionType, 					
				 ActionStatus,
				 OfficerUserId, 
				 OfficerLastName, 
				 OfficerFirstName)
		VALUES ('#get.mission#',
			    '#get.warehouse#',
				'#get.warehouse#',									
				'#batchNo#',	
				'#rowguid#',
				'WOEarmark',			 
				'Unearmark stock for workorder',										
				#dte#,
				'8',		<!--- transfer --->			
				'1',
				'#SESSION.acc#',
				'#SESSION.last#',
				'#SESSION.first#')
	</cfquery>	
			
	<!--- get just has one value here --->
										
	<cfloop query="get">		
					
		<cfset workorderid   = get.workorderid>
		<cfset workorderline = get.workorderline>
		<cfset requirementid = get.requirementid>				
								
		<cfquery name="AccountStock"
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT  GLAccount
				FROM    Ref_CategoryGLedger
				WHERE   Category  = '#ItemCategory#' 
				AND     Area      = 'Stock'
				AND     GLAccount IN (SELECT GLAccount FROM Accounting.dbo.Ref_Account)
		</cfquery>		
		
		<!--- first step we can look at the workorder account --->
																		
		<cfquery name="AccountCOGS"
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT  GLAccount
				FROM    Ref_CategoryGLedger
				WHERE   Category = '#ItemCategory#' 
				AND     Area     = 'COGS'
				AND     GLAccount IN (SELECT GLAccount FROM Accounting.dbo.Ref_Account)
		</cfquery>				
							
		<cfif AccountCOGS.recordcount eq "0" or AccountStock.recordcount eq "0">
		   
		   <table align="center">
		      	<tr>
				   <td class="labelit" align="center">
				   	<font color="FF0000">Attention: GL Account for stock and/or COGS production has not been defined</font>
				   </td>
				</tr>
		   </table>		   
		   
			<script>
				Prosis.busy('no')
			</script>
   
		   <cfabort>
		
		</cfif>
		
		<cfif Category.StockControlMode eq "stock">
												
				<cfset qty = get.transactionQuantity>					
																										
				<cfif isValid("numeric",qty)>		
										
					<cfif qty neq 0>															
												
						<cf_assignid>	
												
						<cfset parid = rowguid>
						
						<!--- -------------------- --->
						<!--- -lower unearmarked-- --->
						<!--- -------------------- --->	
						
						<cf_StockTransact 
						    DataSource            = "AppsMaterials" 
							TransactionId         = "#rowguid#"	
						    TransactionType       = "8"  <!--- transfer --->
							TransactionSource     = "WorkorderSeries"
							ItemNo                = "#ItemNo#" 
							Mission               = "#Mission#" 
							Warehouse             = "#Warehouse#" 
							TransactionLot        = "#TransactionLot#" 						
							Location              = "#Location#"							
							TransactionCurrency   = "#APPLICATION.BaseCurrency#"
							TransactionQuantity   = "#-qty#"
							TransactionUoM        = "#TransactionUoM#"						
							TransactionLocalTime  = "Yes"
							ActionStatus          = "1"
							TransactionDate       = "#dateformat(date,CLIENT.DateFormatShow)#"
							TransactionTime       = "#timeformat(date,'HH:MM')#"
							TransactionBatchNo    = "#batchno#"												
							GLTransactionNo       = "#batchNo#"
							WorkOrderId           = "#workorderid#"
							WorkOrderLine         = "#workorderline#"	
							RequirementId         = "#requirementid#"																
							GLAccountDebit        = "#AccountCOGS.GLAccount#"
							GLAccountCredit       = "#AccountStock.GLAccount#">
						
						<!--- -------------------- --->	
						<!--- --higher earmarked-- --->	
						<!--- -------------------- --->
						
						<cf_assignid>
												
						<!--- new warehouse / location --->
																								
						<cf_StockTransact 
						    DataSource            = "AppsMaterials" 
							TransactionId         = "#rowguid#"	
						    TransactionType       = "8"  <!--- transfer --->
							TransactionSource     = "WorkorderSeries"
							ItemNo                = "#ItemNo#" 
							Mission               = "#Mission#" 																					
							Warehouse             = "#Warehouse#" 										
							Location              = "#Location#"														
							TransactionLot        = "#TransactionLot#" 										
							TransactionCurrency   = "#APPLICATION.BaseCurrency#"
							TransactionQuantity   = "#qty#"
							TransactionUoM        = "#TransactionUoM#"						
							TransactionLocalTime  = "Yes"
							ActionStatus          = "1"
							TransactionDate       = "#dateformat(date,CLIENT.DateFormatShow)#"
							TransactionTime       = "#timeformat(date,'HH:MM')#"
							TransactionBatchNo    = "#batchno#"												
							GLTransactionNo       = "#batchNo#"
							ParentTransactionId   = "#parid#"
							WorkOrderId           = ""
							WorkOrderLine         = ""	
							RequirementId         = "" 					
							GLAccountCredit       = "#AccountCOGS.GLAccount#"
							GLAccountDebit        = "#AccountStock.GLAccount#">											
						
					</cfif>									
										
				</cfif>
					
		<cfelse>
		
			<!--- 	Hanno 18/11/2013 attention the below query could well not be the same as the above query for its total, 
					this has to be carefully analyses and then tuned the query to prevent it 
					
					NOTE: based on the item 
					we are getting the individual source transactions for this item in order to them
					make issuances to the other item from it. 										
			--->		
				
			<cfset qty = get.transactionQuantity>		
																							
			<cfif isValid("numeric",qty)>		
											
					<cfif qty neq 0>															
												
						<cf_assignid>	
						<cfset parid = rowguid>
																			
						<cf_StockTransact 
						    DataSource            = "AppsMaterials" 
							TransactionId         = "#rowguid#"	
							TransactionIdOrigin   = "#Transactionid#"
						    TransactionType       = "8"  <!--- transfer --->
							TransactionSource     = "WorkorderSeries"
							ItemNo                = "#ItemNo#" 
							Mission               = "#Mission#" 
							Warehouse             = "#Warehouse#" 
							Location              = "#Location#"								
							TransactionLot        = "#TransactionLot#" 										
							TransactionReference  = "#TransactionReference#"
							TransactionCurrency   = "#APPLICATION.BaseCurrency#"
							TransactionQuantity   = "#-qty#"
							TransactionUoM        = "#TransactionUoM#"						
							TransactionLocalTime  = "Yes"
							ActionStatus          = "1"
							TransactionDate       = "#dateformat(date,CLIENT.DateFormatShow)#"
							TransactionTime       = "#timeformat(date,'HH:MM')#"
							TransactionBatchNo    = "#batchno#"												
							GLTransactionNo       = "#batchNo#"																				
							WorkOrderId           = "#workorderid#"
							WorkOrderLine         = "#workorderline#"		
							RequirementId         = "#RequirementId#"   																
							GLAccountDebit        = "#AccountCOGS.GLAccount#"
							GLAccountCredit       = "#AccountStock.GLAccount#">
						
						<!--- -------------------------------------------------------- --->	
						<!--- --higher earmarked and create a new source transaction-- --->	
						<!--- -------------------------------------------------------- --->
						
						<cf_assignid>
																				
						<cf_StockTransact 
						    DataSource            = "AppsMaterials" 
							TransactionId         = "#rowguid#"	
						    TransactionType       = "8"  <!--- transfer --->
							TransactionSource     = "WorkorderSeries"
							ItemNo                = "#ItemNo#" 
							Mission               = "#Mission#" 								
							Warehouse             = "#Warehouse#" 
							Location              = "#location#"								
							TransactionLot        = "#TransactionLot#" 																						
							TransactionCurrency   = "#APPLICATION.BaseCurrency#"
							TransactionQuantity   = "#qty#"
							TransactionUoM        = "#TransactionUoM#"						
							TransactionLocalTime  = "Yes"
							ActionStatus          = "1"
							TransactionDate       = "#dateformat(date,CLIENT.DateFormatShow)#"
							TransactionTime       = "#timeformat(date,'HH:MM')#"
							TransactionBatchNo    = "#batchno#"												
							GLTransactionNo       = "#batchNo#"
							ParentTransactionId   = "#parid#"
							WorkOrderId           = ""
							WorkOrderLine         = ""	
							RequirementId         = "" 					
							GLAccountCredit       = "#AccountCOGS.GLAccount#"
							GLAccountDebit        = "#AccountStock.GLAccount#">					
						
				</cfif>		
												
			</cfif>
			
		</cfif>	
							
	</cfloop>
	
</cftransaction>

<cfinclude template="getDetailLines.cfm">


