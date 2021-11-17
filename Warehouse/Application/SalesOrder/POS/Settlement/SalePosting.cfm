
<cfparam name="url.batchid"           default="">
<cfparam name="url.customerid"        default="00000000-0000-0000-0000-000000000000">
<cfparam name="url.customeridinvoice" default="00000000-0000-0000-0000-000000000000">
<cfparam name="url.addressid" 		  default="00000000-0000-0000-0000-000000000000">
<cfparam name="url.warehouse"         default="BCN000">
<cfparam name="url.currency"          default="QTZ">
<cfparam name="url.mode"              default="1">
<cfparam name="url.scope"             default="settlement">
<cfparam name="FORM.SettlementDate"	  default="">
<cfparam name="url.td"	  			  default="">
<cfparam name="url.th"	  			  default="0">
<cfparam name="url.tm"	  			  default="0">

<!--- header datetime --->

<cfif url.td neq "">

	<cfset dateValue = "">
	<CF_DateConvert Value="#url.td#">
	<cfset DTE = dateValue>
		
<cfelse>

	<cfset dateValue = "">
	<CF_DateConvert Value="#FORM.SettlementDate#">
	<cfset DTE = dateValue>
	
</cfif>

<cfoutput>

<cfif URL.addressid eq "">
	<cfset URL.addressid = "00000000-0000-0000-0000-000000000000">
</cfif>	

<cfif url.scope neq "workflow" and url.scope neq "standalone">

	<cfinclude template="OversaleValidation.cfm">

	<cfinvoke  component = "Service.Process.Materials.POS"  
		   method             = "postTransaction" 
		   memo               = "#Form.TransactionMemo#"
		   batchid            = "#url.batchid#"
		   warehouse          = "#url.warehouse#" 
		   terminal           = "#url.terminal#"
		   requestNo          = "#url.requestNo#"  
		   customerid         = "#url.customerid#"
		   customeridinvoice  = "#url.customeridinvoice#"
		   addressid		  = "#url.addressid#"
		   currency           = "#url.Currency#"
		   transactiondate    = "#dateformat(dte,client.dateformatshow)#"		
		   transactionhour    = "#url.th#"
	       transactionminute  = "#url.tm#"  
		   cleanup            = "Yes"
		   returnvariable     = "vBatchId">			   
		   	
<cfelse>

	<cfinvoke  component = "Service.Process.Materials.POS"  
		   method             = "postSettlement" 
		   memo               = "#Form.TransactionMemo#"
		   batchid            = "#url.batchid#"
		   warehouse          = "#url.warehouse#" 
		   terminal           = "#url.terminal#"
		   requestNo          = "#url.requestNo#"
		   customerid         = "#url.customerid#"
		   customeridinvoice  = "#url.customeridinvoice#"
		   addressid		  = "#url.addressid#"
		   currency           = "#url.Currency#"
		   transactiondate    = "#dateformat(dte,client.dateformatshow)#"		
		   transactionhour    = "#url.th#"
	       transactionminute  = "#url.tm#"   
		   cleanup            = "Yes"
		   returnvariable     = "vBatchId">
		   		   
</cfif>		   


<!--- ------------------------------------------------------------------------- --->		   
<!--- if the reposting has not changed the amount, no invoice is being generated --->
<!--- ------------------------------------------------------------------------- --->

<cfquery name="PriorBatch"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * 
	FROM   WarehouseBatch B
	WHERE  BatchId = '#vBatchId#'		
	AND    ParentBatchNo IN (SELECT BatchNo FROM WarehouseBatch WHERE BatchNo = B.ParentBatchNo) 		
</cfquery>				   

<cfif url.scope neq "workflow" and url.scope neq "standalone">
	
	<cfif PriorBatch.recordcount eq "0">
	
		<cfset issueinv = "1">
	
		<!--- no prior transaction, so we invoice --->
		
	<cfelse>
		
		<!--- determine if the total has changed --->
					
		<cfquery name="getParent"
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT * 
				FROM   WarehouseBatch B
				WHERE  BatchNo = '#PriorBatch.ParentBatchNo#'				
		</cfquery>
			
		<cfquery name="getPrior"
			datasource="AppsLedger" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT Journal,JournalSerialNo,DocumentAmount+ISNULL(ABS(AmountOutstanding),0) as Total 
				FROM   TransactionHeader H
				WHERE  TransactionSourceId = '#getParent.BatchId#'	
				AND    TransactionCategory = 'Receipt'				
		</cfquery>		
		
		<cfquery name="getNew"
			datasource="AppsLedger" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT Journal,JournalSerialNo,DocumentAmount +ISNULL(ABS(AmountOutstanding),0) as Total 
				FROM   TransactionHeader H
				WHERE  TransactionSourceId = '#vBatchId#'	
				AND    TransactionCategory = 'Receipt'			
		</cfquery>		
	
		<cfquery name="getPriorSale"
			datasource="AppsLedger" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT Journal,JournalSerialNo,DocumentAmount  +ISNULL(ABS(AmountOutstanding),0) as Total 
				FROM   TransactionHeader H
				WHERE  TransactionSourceId = '#getParent.BatchId#'	
				AND    TransactionCategory = 'Receivables'				
		</cfquery>		
		
		<cfquery name="getNewSale"
			datasource="AppsLedger" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			
				SELECT Journal,JournalSerialNo,DocumentAmount +ISNULL(ABS(AmountOutstanding),0) as Total 
				FROM   TransactionHeader H
				WHERE  TransactionSourceId = '#vBatchId#'	
				AND    TransactionCategory = 'Receivables'			
				
		</cfquery>
		
		<cfquery name="getPriorTotal"
			datasource="AppsLedger" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			
				SELECT SUM(DocumentAmount+ISNULL(ABS(AmountOutstanding),0)) as Total 
				FROM   TransactionHeader H
				WHERE  TransactionSourceId = '#getParent.BatchId#'	
				AND    TransactionCategory = 'Receipt'				
				
		</cfquery>	
		
		<cfquery name="getNewSaleTotal"
			datasource="AppsLedger" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			
				SELECT SUM(DocumentAmount +ISNULL(ABS(AmountOutstanding),0)) as Total 
				FROM   TransactionHeader H
				WHERE  TransactionSourceId = '#vBatchId#'	
				AND    TransactionCategory = 'Receivables'			
				
		</cfquery>				
				
		<!---- Checking  only total values might cause an issue for changing items of the same price as the old one (affecting stock transactions)
		It is suggested to check also the items, if there is a change on them then, issueinv =1
		11/13/2014 
		---->
		
		<!--- <cfif getPrior.total eq getNewSale.Total> --->
        <!--- Here we need a better way to indicate we operate in new e-invoice mode, Armin 10/6/2020 --->
		
		<cfif getPriorTotal.total eq getNewSaleTotal.Total>

				<cfquery name="setNew"
					datasource="AppsMaterials"
					username="#SESSION.login#"
					password="#SESSION.dbpw#">
						UPDATE WarehouseBatch
						SET    BatchReference = '#getParent.BatchReference#'
						WHERE  BatchId = '#vBatchId#'
				</cfquery>

				<cfset issueinv = "0">

		<cfelse>

				<cfset issueinv = "1">

		</cfif>
					
	</cfif>

<cfelse>

	<cfset issueinv = "1">
	
</cfif>


<cfif issueinv eq "0">

	<!--- move the header actions --->
	
	<cfquery name="inherit"
		datasource="AppsLedger" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	
		INSERT INTO TransactionHeaderAction
			
				(Journal, 
				 JournalSerialNo,
				 ActionCode,
				 ActionMode,
				 ActionDate,
				 ActionStatus,
				 ActionReference1,
				 ActionReference2,
				 ActionReference3,
				 ActionReference4,
				 ActionContent,
				 OfficerUserId,
				 OfficerLastName,
				 OfficerFirstName)
			 
		SELECT   '#getNewSale.Journal#', 
			     '#getNewSale.JournalSerialNo#',
				 ActionCode,
				 ActionMode,
				 ActionDate,
				 ActionStatus,
				 ActionReference1,
				 ActionReference2,
				 ActionReference3,
				 ActionReference4,
				 ActionContent,
				 '#session.acc#',
				 '#session.last#',
				 '#session.first#'
				 
		FROM    TransactionHeaderAction
		WHERE   Journal         = '#getPriorSale.Journal#'
		AND     JournalSerialNo = '#getPriorSale.JournalSerialNo#'
		AND     ActionCode      = 'Invoice'
	
	</cfquery>
	
	<script>
		alert("<cf_tl id="Sale updated"> \n\n <cf_tl id="No Invoice was (re-)issued">.")
		try { ProsisUI.closeWindow('wsettle',true)} catch(e){};
		ptoken.navigate("#SESSION.root#/Warehouse/Application/SalesOrder/POS/Sale/applyCustomer.cfm?warehouse=#url.warehouse#",'customerbox')		
	</script>

<cfelse>
			
	<!--- checking if we need to revert through EDI manager 
	Do note that url.batchid is different from vBatchId
	URL.batchId : is the batchId for retrieving purposes
	vBatchId : is the generated Id that was given after calling postTransaction
	11/13/2014 	Armin 
	--->
	
	<cfif url.batchid neq "">
	
			<!--- post the tax action --->
		 	<cfquery name="getAction"
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">					
				SELECT A.*
				FROM   Accounting.dbo.TransactionHeader H
					   INNER JOIN Accounting.dbo.TransactionHeaderAction A ON H.Journal = A.Journal AND H.JournalSerialNo=A.JournalSerialNo
				WHERE  TransactionSourceId = '#URL.batchid#'
				AND    TransactionCategory  = 'Receivables'										
		   	</cfquery>		   	
		   
		    <cfif url.scope neq "standalone">
			
		    	<cfif getAction.recordcount gt "0">
			
			   		<cfif getAction.ActionMode eq "2">

				   		<cfquery name="getBatch"
							datasource="AppsMaterials" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							SELECT * 
							FROM    WarehouseBatch						
							WHERE   BatchId = '#URL.batchid#'
				   		</cfquery>	
						
						<cfinvoke component = "Service.Process.EDI.Manager"  
						   method           = "SaleVoid" 
						   Datasource       = "AppsMaterials"
						   Mission          = "#getBatch.Mission#"
						   Terminal			= "#url.terminal#"	
						   BatchId			= "#URL.BatchId#"
						   returnvariable	= "stResponse">		
						    				
					</cfif>			
				
				</cfif>
				
			</cfif>			
		 	
	</cfif>
	
	<!--- Depending on the sales mode, it triggers the EDI manager for adding up information at
	transactionHeaderAction --->

	<cfif url.scope eq "standalone">
	
		<cfquery name="qCheck" 
	  	datasource="AppsMaterials" 
	  	username="#SESSION.login#" 
	  	password="#SESSION.dbpw#">				
			SELECT * 
			FROM   Accounting.dbo.TransactionHeaderAction
			WHERE  Journal	       = '#getAction.Journal#'
			AND    JournalSerialNo = '#getAction.JournalSerialNo#'
			AND    ActionCode      = 'Invoice'	
			ORDER BY Created DESC		
		</cfquery>		
		
		<cfif qCheck.recordcount eq 0>
		
			<cfinvoke  component = "Service.Process.Materials.POS"  
			   method             = "initiateInvoice" 
			   batchid            = "#url.batchId#"
			   warehouse          = "#url.warehouse#" 
			   terminal           = "#url.terminal#"
			   customerid         = "#url.customerid#"
			   customeridinvoice  = "#url.customeridinvoice#"
			   currency           = "#url.Currency#"	
			   Mode               = "#url.mode#"	   
			   returnvariable     = "vInvoice">
			
			<cfset vActionId = vInvoice.ActionId>


			
		<cfelse>
		
			<cfset vActionId = qCheck.ActionId>		
			
		</cfif>			
	
	<cfelse>
	
		<cfinvoke  component      = "Service.Process.Materials.POS"  
			   method             = "initiateInvoice" 
			   batchid            = "#vBatchId#"
			   warehouse          = "#url.warehouse#" 
			   terminal           = "#url.terminal#"
			   customerid         = "#url.customerid#"
			   customeridinvoice  = "#url.customeridinvoice#"
			   currency           = "#url.Currency#"	
			   Mode               = "#url.mode#"	   
			   returnvariable     = "vInvoice">		
			   
		<cfset vActionId = vInvoice.ActionId>
		
	</cfif>	
			
	<cfif url.scope eq "settlement" or url.scope eq "standard" >
			<script>
				ptoken.navigate("#SESSION.root#/Warehouse/Application/Salesorder/POS/Settlement/SaleInvoice.cfm?actionid=#vActionId#&batchid=#vBatchId#&warehouse=#url.warehouse#&currency=#url.currency#&terminal=#url.terminal#"+"&ts="+new Date().getTime(), 'wsettle');		
				ptoken.navigate("#SESSION.root#/Warehouse/Application/SalesOrder/POS/Sale/applyCustomer.cfm?warehouse=#url.warehouse#",'customerbox')	
				try { opener.applyfilter('1','','#url.customerid#') } catch(e) {}
			</script>
	<cfelseif url.scope eq "standalone">
		<cfif qCheck.recordcount eq 0>
			<script>
				ptoken.navigate("#SESSION.root#/Warehouse/Application/Salesorder/POS/Settlement/SaleInvoice.cfm?actionid=#vActionId#&batchid=#vBatchId#&warehouse=#url.warehouse#&currency=#url.currency#&terminal=#url.terminal#"+"&ts="+new Date().getTime(), 'wsettle');
			</script>
		<cfelse>
			<script>
				try { ProsisUI.closeWindow('wsettle',true)} catch(e){};
				try { window.location.reload();} catch(e){};				
			</script>		
		</cfif>
	<cfelse>	
		<script>
			ptoken.navigate("#SESSION.root#/Warehouse/Application/Salesorder/POS/Settlement/SaleInvoice.cfm?actionid=#vActionId#&batchid=#vBatchId#&warehouse=#url.warehouse#&currency=#url.currency#&terminal=#url.terminal#&scope=#url.scope#"+"&ts="+new Date().getTime(), 'formembed');		
		</script>
	</cfif>	   
		   
</cfif>		   	

<!--- refresh the screen and sets the new customer --->

</cfoutput>	 