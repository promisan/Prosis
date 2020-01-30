

<cfparam name="url.scope" default="Transaction">

<cfquery name="get" 
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT * 
	FROM   ItemTransaction
	WHERE  TransactionId = '#url.drillid#'	
</cfquery>

<!--- we only only issuances that are not POS sales to be changed here --->

<cfif get.TransactionType eq "2" 
   or get.TransactionType eq "5" 
   or get.TransactionType eq "9">

   <cfquery name="bat" 
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT * 
			FROM   WarehouseBatch
			WHERE  BatchNo = '#get.TransactionBatchNo#'			
		</cfquery>
		
	<cfif getAdministrator("*")>	
	
		<cfset access = "ALL">
		
	<cfelseif (findNoCase("Issuance",bat.Batchdescription) 
	            or findNoCase("Retail",bat.Batchdescription) 
	            or get.TransactionType eq "5" 
				or get.TransactionType eq "9") and isValid("GUID","#url.systemfunctionid#")>

		<cfinvoke component = "Service.Access"  
	     method             = "WarehouseProcessor"  
		 role               = "'WhsPick'"
		 mission            = "#get.mission#"
		 warehouse          = "#get.warehouse#"		
		 SystemFunctionId   = "#url.SystemFunctionId#" 
		 returnvariable     = "access">	 	
		 
	<cfelse>
				
		<cfset access = "NONE">	
			 
	</cfif>
						
<cfelse>
	
	<cfset access = "NONE">	
		
</cfif>	


<cfif access eq "NONE">

	<script>
		alert('You have not been granted access to perform this action.')
	</script>	 
	<cfabort>
	 
</cfif>

<!--- 

1. create a copy of the transaction in the ItemTransactionDeny and link to the parent transactionid
2. Update transaction with newly entered values and update Created etc
   if quantity or value changes then we redo the financials as well 

--->

<cfif url.action eq "delete">

	<cf_StockTransactDelete alias="AppsMaterials" 		  
			transactionId="#url.drillid#">		
		
<cfelse>	
	
	<cfparam name="form.transactionReference"    default="#get.TransactionReference#">	
	<cfparam name="Form.AssetId"                 default="#get.AssetId#">
	<cfparam name="Form.OrgUnit"                 default="#get.OrgUnit#">
	<cfparam name="Form.PersonNo"                default="#get.PersonNo#">
	<cfparam name="Form.BillingMode"             default="#get.BillingMode#">
	<cfparam name="Form.Remarks"                 default="#get.Remarks#">
	<cfparam name="Form.TransactionQuantity"     default="#get.TransactionQuantity#">
	<cfparam name="Form.Transaction_date"        default="">
	
	<!--- validate --->
	
	<cfset qty = replace("#Form.TransactionQuantity#",",","","ALL")>
	<cfset qty = replace("#qty#"," ","","ALL")>
	
	<cfif not LSIsNumeric(qty)>
		
			<script>
			    alert('Incorrect quantity')
			</script>	 		
			<cfabort>
		
	</cfif>
	
	<cftransaction>
		
		<cf_StockTransactDelete alias="AppsMaterials" 
		    mode="log" <!--- just to log the old transaction contents --->
			transactionId="#url.drillid#">		
		
		<!--- we need the method to edit the transaction and not to insert --->
		
		<cfif form.transaction_date neq "">
		
			<cfset dateValue = "">
			<CF_DateConvert Value="#form.transaction_date#">
			<cfset DTE = dateValue>
						
			<cfset dte = DateAdd("h","#form.transaction_hour#", dte)>
			<cfset dte = DateAdd("n","#form.transaction_minute#", dte)>
			
		<cfelse>
		
			<cfset dte = get.TransactionDate>	
		
		</cfif>
		
		<!---
		Remed out per Carolina's request because it was -unnecessarily- inverting the sign of the quantity: the TransactionQuantity
		is displayed with the sign inverted, but the value in the Form.TransactionQuantity is passed with the correct sign, thus,
		no need to change it again in this spot.
		
		<cfif get.transactiontype eq "2">
		  <cfset qty = qty*-1>
		</cfif>
		--->
			
		<cfquery name="update" 
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    UPDATE ItemTransaction
			SET    TransactionReference = '#form.transactionReference#' ,
			       Remarks              = '#form.remarks#',
				   BillingMode          = '#Form.BillingMode#',
				   <cfif form.Transaction_Date neq "">
				   TransactionDate      = #dte#,
				   </cfif>
				   <cfif form.assetid neq "">
				   Assetid              = '#form.Assetid#',
				   <cfelse>
				   AssetId              = NULL,
				   </cfif>		
				   <cfif form.OrgUnit neq "">	  
				   OrgUnit              = '#Form.OrgUnit#',			   	 
				   <cfelse>
				   OrgUnit              = '0',
				   </cfif>
				   PersonNo             = '#Form.PersonNo#',
				   TransactionQuantity  = '#qty#',
				   TransactionValue     = '#qty#'*TransactionCostPrice,
				   OfficerUserId        = '#session.acc#',
				   OfficerLastName      = '#session.last#', 
				   OfficerFirstName     = '#session.first#', 
				   Created              = #now()#
			WHERE  TransactionId = '#url.drillid#'
		</cfquery>
		
		<!--- after we update we remove the transaction and financials and repost it completely --->
					
		<!--- get the values, delete the record and then we do the method --->
			
		<cfquery name="get" 
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT * FROM ItemTransaction		
			WHERE  TransactionId = '#url.drillid#'
		</cfquery>
			
		<cfloop query="get">			
		
			<cfquery name="delete" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				DELETE FROM ItemTransaction					
				WHERE  TransactionId = '#url.drillid#'								
			</cfquery>
						
			<cfif get.actionstatus eq "1" and getAdministrator(get.mission) eq "1">
				<cfset status = "1">
			<cfelse>
				<cfset status = "0">							
			</cfif>		
													
			<cf_StockTransact 
			    DataSource            = "AppsMaterials" 
				TransactionId         = "#transactionid#"	
			    TransactionType       = "#TransactionType#"
				TransactionSource     = "WarehouseSeries"
				ItemNo                = "#ItemNo#" 
				Mission               = "#Mission#" 
				Warehouse             = "#Warehouse#" 
				BillingMode           = "#BillingMode#"
				ActionStatus          = "#status#"
				Location              = "#Location#"
				TransactionReference  = "#transactionreference#"
				TransactionCurrency   = "#APPLICATION.BaseCurrency#"
				TransactionQuantity   = "#TransactionQuantity#"
				TransactionUoM        = "#TransactionUoM#"
				TransactionCostPrice  = "#TransactionCostPrice#"
				TransactionLocalTime  = "Yes"
				TransactionDate       = "#dateformat(TransactionDate,CLIENT.DateFormatShow)#"
				TransactionTime       = "#timeformat(TransactionDate,'HH:MM')#"
				TransactionBatchNo    = "#TransactionBatchno#"
				Remarks               = "#remarks#"			
				GLTransactionNo       = "#TransactionbatchNo#"
				WorkOrderId           = "#workorderid#"
				WorkOrderLine         = "#workorderline#"	
				OrgUnit               = "#orgunit#"				
				AssetId               = "#assetid#"
				PersonNo              = "#personno#"	
				BillingUnit           = "#billingunit#"
				ProgramCode           = "#ProgramCode#"
				GLCurrency            = "#APPLICATION.BaseCurrency#"
				GLAccountDebit        = "#GLAccountDebit#"
				GLAccountCredit       = "#GLAccountCredit#">
				
							
			
		</cfloop>
		
		<!--- ----------------------------------------------- --->
		<!--- we clear any events  driven by this transaction --->
		<!--- ----------------------------------------------- --->
		
		<cfif form.assetid neq "">
		
			<cfquery name="getAsset" 
			datasource="appsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT * 
				FROM AssetItem A INNER JOIN Item I ON A.ItemNo = I.ItemNo
				WHERE AssetId = '#form.assetid#'
			</cfquery>		
			
			<cfquery name="qEvents" 
			    datasource="AppsMaterials"  
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT  EC.EventCode, AE.Description 
				FROM    Ref_AssetEventCategory EC INNER JOIN Ref_AssetEvent AE ON EC.EventCode = AE.Code
				WHERE   EC.Category = '#getAsset.Category#' AND EC.ModeIssuance = '1' 	
			</cfquery>
			
			<cfloop query="qEvents">
	
				<cfset date         = Evaluate("FORM.#qEvents.EventCode#_date")>			
				
				<cfif date neq "">
				
					<CF_DateConvert Value="#date#">
					<cfset tDate = dateValue>	
					
					<cfset hour         = Evaluate("FORM.#qEvents.EventCode#_hour")>
					<cfset minute       = Evaluate("FORM.#qEvents.EventCode#_minute")>
					<cfset EventDetails = Evaluate("FORM.#qEvents.EventCode#_details")>
			
				    <cfset vDate = DateAdd("h", hour, tDate)>		
				    <cfset vDate = DateAdd("n", minute, vDate)>
											
					<cfif vDate neq "">
					
							<cfquery name = "qInsertMetric" 
						     datasource="AppsMaterials" 
						     username="#SESSION.login#" 
						     password="#SESSION.dbpw#">
								 DELETE AssetItemEvent
								 WHERE  AssetId          = '#form.assetid#'
								 AND    EventCode        = '#qEvents.EventCode#'
								 AND    TransactionId    = '#url.drillid#'
							 </cfquery>	
							
							<cfquery name = "qInsertMetric" 
						     datasource="AppsMaterials" 
						     username="#SESSION.login#" 
						     password="#SESSION.dbpw#">
								INSERT INTO AssetItemEvent
							    	 ( AssetId, 
									   EventCode, 
									   DateTimePlanning, 
									   EventDetails, 
									   TransactionId, 
									   ActionStatus, 
									   OfficerUserId,
									   OfficerLastName,
									   OfficerFirstName)
								VALUES ('#form.assetid#',
								       '#qEvents.EventCode#',
									   #vDate#,
									   '#EventDetails#',
									   '#url.drillid#',
									   '1',
									   '#SESSION.acc#',
									   '#SESSION.last#',
									   '#SESSION.first#')
							</cfquery>		
			
					</cfif>	
					
				</cfif>	
			
		    </cfloop>		
		
		</cfif>
				
		<!--- ----------------------------------------------- --->
		<!--- we clear any logging driven by this transaction --->
		<!--- ----------------------------------------------- --->
			
		<cfif form.assetid neq "">
			
			<cfquery name="clearAssetAction" 
			datasource="appsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    DELETE FROM AssetItemAction
				WHERE  TransactionId = '#url.drillid#'		
			</cfquery>
				
			<cfquery name="GetActions" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT  DISTINCT RC.ActionCategory, A.ItemNo
				FROM    AssetItem A INNER JOIN Item I ON A.ItemNo = I.ItemNo 
				     	INNER JOIN Ref_Category C ON C.Category = I.Category  		
					    INNER JOIN Ref_AssetActionCategory RC
						ON C.Category = RC.Category AND RC.EnableTransaction = '1'
					<cfif form.assetid eq "">
						WHERE   1=0
					<cfelse>
						WHERE   AssetId = '#Form.AssetId#'	 	
					</cfif>
			</cfquery>
					
			<cfquery name="item" 
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT   *
					FROM     Item
					WHERE    ItemNo = '#GetActions.ItemNo#'				
			</cfquery>
				
			<cfloop query = "GetActions">
			
				<cfquery name="qMetrics" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT Metric
					FROM   Ref_AssetActionMetric
					WHERE  Category       = '#Item.Category#'
					AND    ActionCategory = '#GetActions.ActionCategory#'
				</cfquery>		
										
				<cfloop query="qMetrics">
				
					<cfparam name="Form.#GetActions.ActionCategory#.#qMetrics.Metric#" default="">
												
					<cfset val = evaluate("Form.#GetActions.ActionCategory#.#qMetrics.Metric#")>
									
					<cfset val = replace("#val#",",","","ALL")>
					<cfset val = replace("#val#"," ","","ALL")>
		
					<cfif not LSIsNumeric(val)>
		
						<script>
						    alert('Invalid operation metric')
						</script>	 		
						<cfabort>
		
					</cfif>
									
					<cfif val gte "0">
									
						<cf_AssetAction 
						    DataSource         = "AppsMaterials" 
							TransactionId      = "#url.drillid#"	
							AssetId            = "#Form.AssetId#"
							TransactionDate    = "#dateformat(dte,CLIENT.DateFormatShow)#"
							TransactionTime	   = "#timeformat(dte,'HH:MM')#"
						    Metric1            = "#GetActions.ActionCategory#.#qMetrics.Metric#" 
						    MetricValue1       = "#val#">
						
					</cfif>	
					
				</cfloop>	
			
			 </cfloop>	
		
		</cfif>
		<!--- and eventt --->
	
	</cftransaction>

</cfif>
	
<cfoutput>

<!--- refreshing the batchview --->

<cfif url.scope eq "Transaction">
	
	<script>
		
			ColdFusion.navigate('TransactionViewDetail.cfm?accessmode=view&drillid=#url.drillid#&systemfunctionid=#url.systemfunctionid#','main')
			// refresh the listing 		
			try {				
			if (parent.opener.document.getElementById('mylink')) {		   
			    try {					   
				parent.opener.applyfilter('1','','#url.drillid#') } catch(e) { returnValue = 1}			
			}	} catch(e) {}
				
	</script>
	
<cfelseif url.scope eq "embed">

		<script>
			ColdFusion.navigate('setAssetDetail.cfm?field=asset&transactionid=#url.drillid#','asset_#url.drillid#')		
			ColdFusion.navigate('setAssetDetail.cfm?field=metric&transactionid=#url.drillid#','metric_#url.drillid#')	
			ColdFusion.navigate('setAssetDetail.cfm?field=person&transactionid=#url.drillid#','person_#url.drillid#')	
		</script>
				
</cfif>

</cfoutput>
